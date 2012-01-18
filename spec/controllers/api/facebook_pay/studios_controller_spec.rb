require 'spec_helper'


describe Api::FacebookPay::StudiosController do

  def stub_request_facebook_graph_info_to_include(data)
    controller.stub_chain(:facebook, :data).and_return(data)
  end


  def set_request_order_info_for_credits_data_to(order_json)
    @credits_data['credits']['order_info'] = order_json
  end

  describe("When facebook calls our #callback method") do
#    TODO: Is this a security hole? The movie is not connected to the studio at all
    let(:movie) do
      Factory(:movie,
              :pay_dialog_title => "Top Gun",
              :description => "Lots of planes fighting",
              :price => 110)
    end
    let(:studio) { studio = Factory(:studio) }
    let(:order_info) do
      {
          'movie_id' => movie.id,
          'cost' => 110,
          'tax' => 10,
          'zip_code' => '01609',
      'discount_key' => 'null'
      }
    end
    let(:order_info_with_discount) do
      {
          'movie_id' => movie.id,
          'cost' => 110,
          'tax' => 10,
          'zip_code' => '01609',
          'discount_key' => 'foo'
      }
    end
    before(:each) do
      @credits_data = {
          'credits' => {}
      }
      stub_request_facebook_graph_info_to_include(@credits_data)
      @params = {:studio_id => studio.id}
    end

    context(":method => 'payments_get_items'") do
      let(:request_to_make) do
        lambda do
          @params[:method] = 'payments_get_items'
          set_request_order_info_for_credits_data_to(order_info.to_json)
          post :callback, @params
        end
      end

      it 'returns item information for facebook to display' do
        response_to_send_back_to_facebook = {
            :content => [
                {:item_id => movie.id.to_s,
                 :title => movie.pay_dialog_title,
                 :description => movie.description,
                 :price => 120,
                 :image_url => movie.skin.facebook_dialog_icon.url,
                 :product_url => movie.skin.facebook_dialog_icon.url,
                 :data => order_info.to_json}
            ],
            :method => 'payments_get_items'
        }
        request_to_make.call
        response.body.should == response_to_send_back_to_facebook.to_json
      end

      it "should set the price based on the absolute value of tax" do
        order_info['tax'] = -20
        set_request_order_info_for_credits_data_to(order_info.to_json)
        request_to_make.call
        item = JSON.parse(response.body)['content'].first
        item['price'].should == 130  # price + abs(tax)
      end

      it "uses the stored value of the price even if user hacks the request" do
        movie.update_attributes :price => 27

        order_info['tax'] = 0
        order_info['cost'] = 2
        set_request_order_info_for_credits_data_to(order_info.to_json)

        request_to_make.call
        item = JSON.parse(response.body)['content'].first
        item['price'].should == 27
      end

      it 'should take the ceiling of tax as a float' do
        #this should never happen, as it should have already gone through tax calculator
        movie.update_attributes(:price => 30)
        order_info['tax'] = 2.11
        set_request_order_info_for_credits_data_to(order_info.to_json)
        request_to_make.call
        item = JSON.parse(response.body)['content'].first
        item['price'].should == 33
      end
    end

    context ":method => 'payments_status_update'" do
      before do
        @params[:method] = 'payments_status_update'
      end

      context ":status => 'placed'" do
        before do
          @facebook_user = Factory(:user, :facebook_user_id => '12345')
          @details = {
              'buyer' => @facebook_user.facebook_user_id,
              'order_id' => 23456,
              'status' => 'placed',
              'items' => [{'data' => order_info.to_json}]
          }

          @credits_data['credits']['order_details'] = @details.to_json
        end

        let(:request_to_make) { lambda { post :callback, @params } }

        it 'creates an Order record in our database with a status of placed' do
          expect { request_to_make.call }.to change { Order.count }.by(1)
          order = Order.last
          order.facebook_order_id.should == '23456'
          order.status.should == 'placed'
          order.movie_id.should == movie.id
        end

        it "should attatch the facebook user to the order" do
          request_to_make.call
          Order.last.user.should == @facebook_user
        end

        it 'should reply with a settled JSON response' do
          request_to_make.call

          json_response = {
              :content => {
                  :order_id => 23456,
                  :status => 'settled'
              },
              :method => 'payments_status_update'
          }.to_json

          response.body.should == json_response
        end
      end

      context "when :status => 'settled' with an existing Order" do
        before do
          @user = Factory(:user)
          @order = Order.create(
              :facebook_order_id => '98765',
              :user_id => @user.id,
              :status => 'placed'
          )

          @order.status.should == 'placed'
          @order.rented_at.should be_nil

          Timecop.freeze(@time_of_post = Time.now.utc)

          @details = {
              'order_id' => 98765,
              'status' => 'settled'
          }

          @credits_data['credits']['order_details'] = @details.to_json

          post :callback, @params
          @order.reload
        end

        it "should settle the order" do
          @order.status.should == 'settled'
        end

        it "should set the rented_at" do
          @order.rented_at.should == @time_of_post
        end

        it "should return nothing in the body" do
          nothing = " "
          response.body.should == nothing
        end
      end

      context "when :status => 'disputed'" do
        before do
          @user = Factory(:user)
          @order = Order.create(
              :facebook_order_id => '98765',
              :user_id => @user.id,
              :status => 'settled'
          )
          @order.status.should == 'settled'


          @details = {
              'order_id' => 98765,
              'status' => 'disputed'
          }
          @credits_data['credits']['order_details'] = @details.to_json

          post :callback, @params
          @order.reload
        end

        it "should settle the order" do
          @order.status.should == 'disputed'
        end

        it "should return nothing in the body" do
          nothing = " "
          response.body.should == nothing
        end
      end
    end
  end
end