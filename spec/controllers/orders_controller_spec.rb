require 'spec_helper'

describe OrdersController do
  render_views
  describe "GET new" do
    before { @movie = Factory :movie, :price => 30 }
    context "with a valid zipcode" do
      context "that taxes our product" do
        before do
          PriceCalculator.should_receive(:prices_for).with(@movie.price, '98111').
              and_return({:price => 1, :tax => 2, :total => 3})
          get :new, :movie_id => @movie.id, :zip => '98111', :studio_id => @movie.studio.id
        end

        it "renders the new template" do
          response.should render_template(:new)
          response.status.should == 200
        end

        it "assigns a hash with the order price information" do
          assigns(:order)[:price].should == 1
          assigns(:order)[:tax].should == 2
          assigns(:order)[:total].should == 3
          assigns(:order)[:zip_code].should == '98111'
        end
      end
      context "that doesn't tax" do
        it "should render 200" do
          PriceCalculator.should_receive(:prices_for).with(@movie.price, '01609').
              and_return({:price => 1, :tax => 0, :total => 1})
          get :new, :movie_id => @movie.id, :zip => '01609', :studio_id => @movie.studio.id
          response.status.should == 200
          #response.body.should == {:movie_id => @movie.id, :price => @movie.price, :tax => 0, :zip_code => '98111'}.to_json
        end
      end
    end

    context "with an invalid zip code" do
      context "with a bad zip code" do
        use_vcr_cassette 'tax info for invalid zip', :record => :new_episodes
        it "should respond with please enter a valid zipcode" do
          get :new, :movie_id => @movie.id, :zip => '0', :studio_id => @movie.studio.id
          response.body.should match "Please enter a valid Zip Code"
          response.status.should == 400
        end
      end

      context "without a zipcode" do
        it "returns 404" do
          get :new, :movie_id => @movie.id, :studio_id => @movie.studio.id
          response.body.should match "Please enter a valid Zip Code"
          response.status.should == 400
        end
      end
    end

  end

  describe "GET show" do
    context "with an authenticated user" do
      before do
        @fb_user = Factory(:user)
        FbGraph::Auth.stub_chain(:new, :user).and_return(
            double('mock_fb_user', :identifier => @fb_user.facebook_user_id, :name => @fb_user.name))
        @order = Factory :settled_order
      end

      it "should only show orders for the studio and movie passed in" do
        order = Factory(:order)
        other_order = Factory(:order)
        get :show, :id => order.id, :movie_id => order.movie.id, :studio_id => order.movie.studio.id
        response.should be_success
        expect {
          get :show, :id => order.id, :movie_id => other_order.movie.id, :studio_id => other_order.movie.studio.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context "with a valid order" do
        let(:request_to_make) do
          lambda {
            get :show, :id => @order.id, :movie_id => @order.movie.id,
                :studio_id => @order.movie.studio.id
          }
        end

        it "renders the show template (watch page)" do
          request_to_make.call
          assigns(:movie).should == @order.movie
          response.should render_template(:show)
        end

        it "should store our visit" do
          expect {
            request_to_make.call
          }.to change {
            @order.movie.page_visits.where(:page => 'watch', :user_id => @fb_user.id).count
          }.by(1)
        end

        it "should store the ip we're visiting with" do
          @request.env['REMOTE_ADDR'] = '204.16.153.246'
          @order.ip_addresses.should be_empty
          request_to_make.call
          @order.reload.ip_addresses.first.ip.should == '204.16.153.246'
        end

        context "Warner movie" do
          it "allows the user to watch the order when the ip_is_ok" do
            @order.movie.studio.update_attributes(:name => 'Warner', :player => 'warner')
            Order.stub(:find).and_return(@order)
            @order.stub!(:is_ip_ok?).and_return(true)
            request_to_make.call
            Nokogiri::HTML(response.body).css("#mediaspace").should be_present
          end
        end

        context "Not a warner movie" do
          it "allows the user to watch the order when the ip_is_ok" do
            @order.movie.studio.update_attributes(:name => 'FUNamation', :player => 'brightcove')
            Order.stub(:find).and_return(@order)
            @order.stub!(:is_ip_ok?).and_return(true)
            request_to_make.call
            Nokogiri::HTML(response.body).css("#brightcovePlayer").should be_present
          end
        end

        it "doesn't allow the user to watch the order when ip_is_ok is sad" do
#         TODO: undo this ish. No need to deal with all this stubbing
          Studio.stub(:find).and_return(@order.movie.studio)
          @order.movie.studio.stub_chain(:movies, :find).and_return(@order.movie)
          @order.movie.stub_chain(:orders, :find).and_return(@order)
          @order.stub!(:is_ip_ok?).and_return(false)
          request_to_make.call
          response.body.should match("We're sorry, but you have exceeded the maximum number of devices allowed to playback your purchase.")
        end
      end

      context "with a valid order and show_facebook_feed_dialog parameter" do
        context "that is true" do
          it "should expose show_facebook_feed_dialog as true" do
            get :show, :id => @order.id, :movie_id => @order.movie.id,
                :studio_id => @order.movie.studio.id, :show_facebook_feed_dialog => 'true'
            assigns(:show_facebook_feed_dialog).should be_true
          end
        end
        context "that is not true" do
          it "should expose show_facebook_feed_dialog as true" do
            get :show, :id => @order.id, :movie_id => @order.movie.id,
                :studio_id => @order.movie.studio.id, :show_facebook_feed_dialog => nil
            assigns(:show_facebook_feed_dialog).should == "false"
          end
        end
      end

      context "with an old order" do
        before do
          @order.update_attribute :rented_at, @order.rented_at - @order.movie.rental_length - 1
          Order.stub!(:find).and_return(@order)
          get :show, :id => @order.id, :movie_id => @order.movie.id,
              :studio_id => @order.movie.studio.id
        end

        it "redirects to the movie's purchase page" do
          response.should redirect_to(studio_movie_path(@order.movie.studio, @order.movie))
        end

        it "does not log the ip" do
          @order.ip_addresses.should be_empty
        end

        it "does not log the page visit" do
          @order.reload.movie.page_visits.should be_empty
        end
      end
    end
  end
end