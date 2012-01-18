class Api::FacebookPay::StudiosController < ApplicationController
  skip_before_filter :validate_geo_restriction
  
  def callback
    @studio = Studio.find(params[:studio_id])
    content = case params[:method]
                when 'payments_get_items'
                  payments_get_items
                when 'payments_status_update'
                  payments_status_update
              end

    json = {
        :content => content,
        :method => params[:method]
    }

    if content
      render :json => json
    else
      render :nothing => true
    end
  end

  private

  def validate_against_hack(discount_key,movie)
    price = nil
    if discount_key == 'null' || discount_key == 'false'
      price = movie.price
    else
      group_discount = GroupDiscount.find_by_discount_key(discount_key)
      group_discount ? price = (movie.price - 10) : price = movie.price
    end
    price
  end

  def return_information_to_facebook_about_items_to_purchase
    order_info = JSON.parse(facebook.data['credits']['order_info'])
    movie = Movie.find(order_info['movie_id'])
    tax = BigDecimal.new(order_info['tax'].to_s).abs

    # protecting against hacking and checking on the server side again.
    if movie.series
      price = order_info['cost'] if (order_info['cost'] == movie.series.price)
    else
      price = validate_against_hack(order_info['discount_key'],movie)
    end


    total_cost = (price + tax).ceil

    [
        {:item_id => order_info['movie_id'].to_s,
         :title => movie.pay_dialog_title,
         :description => movie.description,
         :price => total_cost,
         :image_url => movie.skin.facebook_dialog_icon.url,
         :product_url => movie.skin.facebook_dialog_icon.url,
         :data => facebook.data['credits']['order_info']}
    ]
  end

  alias_method :payments_get_items, :return_information_to_facebook_about_items_to_purchase

  def create_or_update_an_order_from_facebook_purchase_event
    order_details = JSON.parse(facebook.data['credits']['order_details'])
    fb_order = Order::FacebookOrder.new(order_details)
    @order = Order.process_from_fb_order(fb_order)
    fb_order.status == "placed" ? {:order_id => @order.facebook_order_id.to_i, :status => 'settled'} : false
  end

  alias_method :payments_status_update, :create_or_update_an_order_from_facebook_purchase_event
end