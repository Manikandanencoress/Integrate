require 'spec_helper'

describe Order do
  describe "associations" do
    it "should belong_to :movie" do
      Order.reflect_on_association(:movie).macro.should == :belongs_to
    end

  end


  describe "#expired?" do
    it "should return true when we are past the movie's expiration time" do
      movie = Factory(:movie, :rental_length => 1)
      order = Factory(:order, :movie => movie, :rented_at => Date.yesterday, :status => 'settled')
      order.should be_expired
    end

    it "should return false when we are not past the movie's expiration time" do
      movie = Factory(:movie, :rental_length => 2.days.seconds)
      order = Factory(:order, :movie => movie, :rented_at => Time.now, :status => 'settled')
      order.should_not be_expired
    end

    it "should return false when its status is not 'settled'" do
      order = Factory :order, :status => ''
      order.should_not be_expired
    end

    it "should return true when the movie doesn't exist any more" do
      order = Factory :order, :status => 'settled', :rented_at => 5.minutes.from_now
      order.movie.destroy
      order.reload.should be_expired
    end
  end

  describe ".process_from_fb_object" do

    def build_facebook_order(status, fb_user_id, order_id, total, zip_code, tax)
      facebook_order = Order::FacebookOrder.new({})
      facebook_order.status = status
      facebook_order.user_id = fb_user_id
      facebook_order.order_id = order_id
      facebook_order.total = total
      facebook_order.zip_code = zip_code
      facebook_order.tax_collected = tax
      facebook_order
    end

    context "when the fb_object is placed" do
      context "with a valid facebook user" do
        let(:facebook_user) { Factory(:user, :facebook_user_id => '200003') }
        let(:fb_order) do
          facebook_order = Order::FacebookOrder.new({})
          facebook_order.status = 'placed'
          facebook_order.user_id = facebook_user.facebook_user_id
          facebook_order.order_id = 32323232
          facebook_order.total = 14
          facebook_order.zip_code = '98111'
          facebook_order.tax_collected = 4
          facebook_order
        end

        it "should set the amount of facebook credits spent" do
          order = Order.process_from_fb_order(fb_order)
          order.reload.total_credits.should == 14
        end
      end

      context "without a valid facebook user" do
        let(:fb_order) {
          build_facebook_order('placed', 'haxor_who_has_never_used_the_systems_fb_id',
                               32323232, 14, '98111', 4)
        }

        it "should raise an error" do
          lambda { Order.process_from_fb_order(fb_order) }.should raise_error
        end
      end
    end

    context "when fb_object is disputed" do
      let(:facebook_order_id) { '1234' }
      let(:fb_order) {
        build_facebook_order('disputed', 'user_id', facebook_order_id, 11, '98111', 14)
      }
      it "should dispute the order" do
        order = Factory(:order, :facebook_order_id => facebook_order_id)
        Order.process_from_fb_order(fb_order)
        order.reload.status.should == 'disputed'
      end
    end
  end

  describe "#settle!" do
    let(:order) { Factory(:order) }
    let(:settled_time) { Time.now.utc }
    before do
      Timecop.freeze(settled_time)
    end

    it "should change our status to 'settled'" do
      expect { order.settle! }.to change(order, :status).to('settled').from(nil)
    end

    it "should set rented_at to right now" do
      expect { order.settle! }.to change(order, :rented_at).to(settled_time).from(nil)
    end
  end

  describe "#dispute!" do
    let(:order) { Factory(:order) }
    it "should change our status to disputed" do
      expect { order.dispute! }.to change(order, :status).from(nil).to('disputed')
    end
  end

  describe "#refund!" do
    context "order is disputed" do
      let(:order) { Factory(:order, :status => 'disputed') }

      before do
        mock_fb_app = double('mock_fb_ap', :get_access_token => 'foo')
        @mock_order = double('mock_order')

        FbGraph::Application.stub(:new).and_return(mock_fb_app)
        FbGraph::Order.stub(:new).and_return(@mock_order)
      end

      context "with a successful facebook refund call" do
        before do
          @mock_order.should_receive(:refunded!).with({:refund_funding_source => nil, :message => anything()}).and_return(true)
        end

        it "should dispute teh order" do
          order.status.should == 'disputed'
          order.refund!
          order.reload.status.should == 'refunded'
        end
      end

      context "when refunded errors" do
        before do
          @mock_order.should_receive(:refunded!).and_raise(FbGraph::NotFound.new("ahoy"))
        end
        it "should raise and leave the order disputed" do
          lambda { order.refund! }.should raise_error("Failed to refund facebook order")
          order.reload.status.should == 'disputed'
        end
      end

      context "when refunded returns false" do
        before do
          @mock_order.should_receive(:refunded!).and_return(false)
        end
        it "should raise and leave the order disputed" do
          lambda { order.refund! }.should raise_error("Failed to refund facebook order")
          order.reload.status.should == 'disputed'
        end
      end
    end

    context "order is not disputed" do
      it "should fail" do
        order = Factory(:order, :status => 'settled')
        lambda { order.refund! }.should raise_error("Can only refund disputed orders")
      end
    end
  end

  describe "is_ip_ok?(ip)" do
    let(:order) { Factory :settled_order }
    let(:studio) { order.movie.studio }
    before do
      studio.update_attributes(:max_ips_for_movie => 3)
      ['foo', 'bar', 'baz'].each do |ip_address|
        order.ip_addresses.create! :ip => ip_address
      end
    end

    it "returns true for the studio's limited number of IP addresses in the ip list" do
      order.is_ip_ok?('foo').should be_true
      order.is_ip_ok?('bar').should be_true
      order.is_ip_ok?('baz').should be_true
    end

    it "returns false for anything past the studios ip limit" do
      studio.update_attributes(:max_ips_for_movie => 2)
      order.is_ip_ok?('foo').should be_true
      order.is_ip_ok?('bar').should be_true
      order.is_ip_ok?('baz').should be_false
    end
  end

  describe "#log_ip" do
    let(:order) { Factory :settled_order }
    it "stores the ip address in an associated IpAddress" do
      order.log_ip('foo.bar')
      order.ip_addresses.map(&:ip).should include('foo.bar')
    end

    it "only stores an ip address once in order" do
      order.log_ip('foo')
      order.log_ip('bar')
      order.log_ip('foo')
      order.ip_addresses.map(&:ip).should == ['foo', 'bar']
    end
  end
end
