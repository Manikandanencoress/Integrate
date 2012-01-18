require 'spec_helper'

describe Api::WbPlayerAuthorizationsController do
  describe "GET #index" do
    before do
      @movie = Factory :movie, :cdn_path => 'bar', :video_file_path => 'baz'
      WbTokenGenerator::TokenGenerator.stub!(:generate).
          with('bar', 'baz').
          and_return('foo')
      @user = Factory(:user)
      @user.save!
      @order = Order.create(
              :user => @user,
              :movie_id => @movie.id)
      @order.log_ip('204.16.153.246')
      @request.env['REMOTE_ADDR'] = '204.16.153.246'
    end

    it "returns a bad code if an order isn't settled" do
      get :index, :movie_id => @movie.to_param, :facebook_user_id => @user.facebook_user_id
      response.status.should == 200
      @response_json = JSON.parse(response.body)

      @response_json['result'].should == '0'
      @response_json['eid'].should == 1000
    end

    it "returns a bad code if the user is not one of their top 3 IPs for the order" do
      @order.settle!
      @order.stub!(:whitelisted_ips).and_return(['204.16.153.101', '204.16.153.102', '204.16.153.103'])
      @request.env['REMOTE_ADDR'] = "204.16.153.246"
      Order.stub_chain(:where, :order, :last).and_return(@order)
      get :index, :movie_id => @movie.to_param, :facebook_user_id => @user.facebook_user_id
      @response_json = JSON.parse(response.body)
      @response_json['result'].should == '0'
      @response_json['eid'].should == 1000
    end

    context "when we have gross params with a trailing slash" do
      it "should remove the trailing slash" do
        expect { get :index, :movie_id => '1234/', :facebook_user_id => "#{@user.facebook_user_id}/" }.to_not raise_error
      end
    end

    context "we have an order" do
      before { @order.settle! }
      context "that is not expired" do
        before do
          @movie.update_attribute :rental_length, 200
          @order.update_attribute :rented_at, Time.now
          get :index, :movie_id => @movie.to_param, :facebook_user_id => @user.facebook_user_id
          response.should be_success
          @response_json = JSON.parse(response.body)
        end

        it "returns a JSON authorization response" do
          @response_json['result'].should == '1'
        end

        it "returns JSON with the media location & params" do
          @response_json['media'].should == 'foo'
        end


      end

      context "that is expired" do

        it "returns the movie expired error code" do
          @movie.update_attribute :rental_length, 100
          @order.update_attribute :rented_at, 101.seconds.ago

          get :index, :movie_id => @movie.to_param, :facebook_user_id => @user.facebook_user_id
          response.should be_success
          @response_json = JSON.parse(response.body)

          @response_json['result'].should == '0'
          @response_json['eid'].should == 1006
        end
      end
    end

    context "we don't have an order" do
      before do
        Order.destroy_all
        get :index, :movie_id => @movie.to_param, :facebook_user_id => @user.facebook_user_id
        response.should be_success
        @response_json = JSON.parse(response.body)
      end

      it "returns a not authorized response" do
        @response_json['result'].should == '0'
      end

      it "returns an error code" do
        @response_json['eid'].should be_present
      end
    end

    context "we have multiple orders" do
      context "and the last one of them is not expired" do
        it 'should return a valid stream' do
          @movie.update_attribute :rental_length, 10
          expired_order = Factory(:order, :movie => @movie, :rented_at => 2.days.ago, :user => @user, :status => 'settled')
          active_order = Factory(:order, :movie => @movie, :rented_at => 2.days.from_now, :user => @user, :status => 'settled')
          active_order.log_ip('204.16.153.246')
          get :index, :movie_id => @movie.to_param, :facebook_user_id => @user.facebook_user_id
          JSON.parse(response.body)['result'].should == '1'
        end
      end
    end
  end
end
