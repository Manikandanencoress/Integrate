class OrdersController < ApplicationController

  skip_before_filter :validate_geo_restriction

  def new
    if params[:zip].blank?
      status = :blank_zip
    else
      begin
        @movie = Movie.find(params[:movie_id])
        coupon = Coupon.find_by_code params[:coupon_code]
        the_price = coupon.try(:price) || @movie.price
        @order = PriceCalculator.prices_for(the_price, params[:zip])
        @order[:zip_code] = params[:zip]
        status = @order[:tax].to_i > 0 ? :taxed : :untaxed
      rescue TaxRateService::InvalidZipError => e
        status = :invalid_zip
      end
    end

    case status
      when :taxed
        render :layout => false
      when :untaxed
        render :layout => false
      else
        render :status => 400, :text => "Please enter a valid Zip Code"
    end
  end


  def show
    @studio = Studio.find(params[:studio_id])
    @movie = @studio.movies.find(params[:movie_id])
    @order = @movie.orders.find(params[:id])

    redirect_if_expired and return
    load_facebook_user
    @movie.page_visits.for_watch_page.create! :user => @facebook_user
    @order.log_ip(request.ip)

    @show_facebook_feed_dialog = params['show_facebook_feed_dialog'] == 'true'

    if @show_facebook_feed_dialog == false
      @show_facebook_feed_dialog = browser_ie_less_than_9
    end

    @show_facebook_feed_dialog_with_group_discount = params['show_facebook_feed_dialog_with_group_discount'] == 'true'
    @discount_key_link = params['discount_key_link']
    @expired = params['expired']
    @viewing_party_complete = params['viewing_party_complete']
    create_group_discount(@order) if @show_facebook_feed_dialog_with_group_discount
    create_redeem_offer(@order) if params['discount_key']
    @ip_can_watch_movie = @order.is_ip_ok?(request.ip)
  end

  def cookie
    order = Order.find(params[:order_id])
    order.update_attribute(:left_at, params[:left_at])
  end

  def fb_popped_up
    ie = IeIssue.find_or_create_by_movie_id_and_user_id params[:movie_id], @facebook_user.id
    ie.update_attribute :fb_popped_up, true
    puts "browser ie has been displayed!"
  end

  def flash_config
    respond_to do |format|
      order = Order.find(params[:order_id])
      scraped_key = params[:flash_config].split(/flash_config/).second.split(".").first
      @movie = order.movie
      format.f4m if order.flash_config_key == scraped_key
    end
  end

  private

  def create_group_discount(order)
    key = params['discount_key_link'].split(/discount_key=/).last
    GroupDiscount.create!(:order_id => order.id, :discount_key => key)
  end

  def create_redeem_offer(order)
    unless params['discount_key'] == 'false' || params['discount_key'] == 'null'
      group_discount = GroupDiscount.find_by_discount_key(params['discount_key'])
      if group_discount != nil
        RedeemDiscount.create(:order_id => order.id, :group_discount_id => group_discount.id)
      end
    end
  end


  def redirect_if_expired
    redirect_to studio_movie_path(@order.movie.studio, @order.movie) if @order.expired?
  end

end