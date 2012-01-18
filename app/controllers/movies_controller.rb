class MoviesController < ApplicationController
  before_filter :load_facebook_user, :only => [:index, :show, :check_coupon]
  skip_before_filter :validate_geo_restriction, :only => :check_coupon

  def index
    @studio = Studio.find(params[:studio_id])
    @filter = Filter::Genre.new(params[:filter])
    @active_rentals = @facebook_user.try(:currently_rented_movies_for_studio, @studio).to_a
    @movies_without_series_titles = @studio.titles - @studio.titles.select {|t| t.series_id == nil }
    @movies = @filter.filter_movie_scope(@studio.movies.viewable_for_user(@facebook_user.try(:facebook_user_id))).
        order("LOWER(title)").includes(:skin, :studio) - @active_rentals - @movies_without_series_titles
  end

  def show
    @studio = Studio.find(params[:studio_id])
    @movie = @studio.movies.viewable_for_user(@facebook_user.try(:facebook_user_id)).find_by_id(params[:id])
    @discount_key_link = @movie.generate_discount_link if @movie
    @studio.group_buy_enabled ? @group_buy_enable = true : @group_buy_enable = false #to guard against nil

    if params['discount_key']
      group_discount = GroupDiscount.find_by_discount_key(params['discount_key'])
      if group_discount
        valid, @expired, @viewing_party_complete = group_discount.validate_discount_key
        valid ? @discount_key = params['discount_key'] : @discount_key = false
      else
        @discount_key, @expired, @viewing_party_complete = false, false, false
      end
    end

    redirect_to :action => 'index' and return unless @movie

    render :template => 'movies/splash' and return unless @facebook_user

    if params[:zero_price]
      if @movie.price.zero? # prevent hacking
        unless @movie.active_orders_for(@facebook_user).first
          @order = Order.create(:movie_id => @movie.id, :user_id => @facebook_user.id, :status => 'settled',
                                :rented_at => Time.now, :total_credits => 0, :facebook_order_id => nil)
        else
          @order = @movie.active_orders_for(@facebook_user).first
        end
        redirect_to studio_movie_order_path(@movie.studio.id, @movie.id, @order.id,
                                            :signed_request => params[:signed_request],
                                            :show_facebook_feed_dialog => params[:show_facebook_feed_dialog]
                    )
      end

    elsif order = @movie.active_orders_for(@facebook_user).first
      redirect_to studio_movie_order_path(@movie.studio.id, @movie.id, order.id,
                                          :signed_request => params[:signed_request],
                                          :show_facebook_feed_dialog => params[:show_facebook_feed_dialog],
                                          :show_facebook_feed_dialog_with_group_discount => params[:show_facebook_feed_dialog_with_group_discount],
                                          :discount_key_link => params[:discount_key_link], :discount_key => params[:discount_key],
                                          :expired => params[:expired], :viewing_party_complete => params[:viewing_party_complete])
    else
      @shares = { :clips => Clip.most_pop_by_movie(@movie.id), :quotes => Quote.most_pop_by_movie(@movie.id) }

      @movie.page_visits.for_purchase_page.create! :user => @facebook_user

      @restrict_age = @movie.restricted_for?(@facebook_user)

      @paypal_token = Paypal.initial_token_for request, @movie, @facebook_user.id, 0 if @studio.paypal_enabled

      render :template => 'movies/purchase'
    end
  end

  def fan_pages
    studio = Studio.find(params[:studio_id])
    movie = studio.movies.find_by_facebook_fan_page_id(facebook.data['page']['id'])
    if movie
      redirect_to [studio, movie]
    else
      redirect_to [studio, Movie]
    end
  end

  def check_coupon
    @coupon = Coupon.find_by_code params[:code]
    if @coupon && @coupon.price
      code = '200'
      if @coupon.movie.studio.paypal_enabled?
        paypal_token = Paypal.initial_token_for(@coupon.movie, @facebook_user.try(:id), 0, @coupon.price)
        the_url = Paypal.incontext_url paypal_token
      end
    else
      code = '403'
    end

    render :json => {
        :status => code,
        :price => @coupon.try(:price),
        :percent => @coupon.try(:percent),
        :paypal_incontext_url => the_url},
           :status => code
  end

  def paypal_return
    paypal = Paypal.movie_info params[:token], params[:studio_id]
    movie = Movie.find paypal[:movie_id]
    order = Order.create :movie_id => movie.id, :status => 'paypal_pending',
                         :user_id => params[:user_id]

    order.reload

    @params = Paypal.charge_transaction request,
                                        params[:token],
                                        params[:PayerID],
                                        order,
                                        paypal[:fb_signed_request]
    @the_url = order.movie.studio.facebook_canvas_page +
        "movies/" +
        order.movie_id.to_s +
        "?show_facebook_feed_dialog=true"
  end

  def paypal_cancel
    movie = Movie.find params[:movie_id]
    @the_url = movie.studio.facebook_canvas_page +
        "movies/" + movie.id.to_s
  end

  private

  def validate_discount_key
    group_discount = GroupDiscount.find_by_discount_key(params['discount_key'])
    valid, expired, viewing_party_complete = true, true, true

    if group_discount
      redeemed_orders = RedeemDiscount.find_all_by_group_discount_id(group_discount.id)

      if expired?(group_discount)
        valid, expired, viewing_party_complete = false, true, false
      elsif viewing_party_complete?(redeemed_orders.count)
        valid, expired, viewing_party_complete = false, false, true
      else
        valid, expired, viewing_party_complete = true, false, false
      end

    else
      valid, expired, viewing_party_complete = false, false, false
    end

    [valid, expired, viewing_party_complete]
  end


  def expired?(group_discount)
    group_discount.created_at < 7.days.ago ? true : false
  end

  def viewing_party_complete?(count)
    count > 5 ? true : false
  end

end
