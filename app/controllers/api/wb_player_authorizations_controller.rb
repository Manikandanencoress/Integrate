class Api::WbPlayerAuthorizationsController < ApplicationController
  before_filter :tolerate_slashes_in_params, :only => :index
  before_filter :set_cache_buster
  skip_before_filter :validate_geo_restriction
  

  GENERAL_ERROR = {:result => '0', :eid => 1000}

  def index
    user = User.find_by_facebook_user_id!(params[:facebook_user_id])
    order = Order.where(:movie_id => params[:movie_id],
                        :user_id => user.id,
                        :status => 'settled').order(:rented_at).last
    response = case
                 when order.nil?
                   GENERAL_ERROR
                 when order.expired?
                   {:result => '0', :eid => 1006}
                 when !order.is_ip_ok?(request.ip)
                   GENERAL_ERROR
                 else
                   movie = Movie.find(params[:movie_id])
                   {:result => '1', :media => movie.media_path}
               end
    render :json => response
  end

  private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def tolerate_slashes_in_params
    # delete the trailing slash that the wb_player likes to append
    params[:movie_id] = params[:movie_id].delete('/')
    params[:facebook_user_id] = params[:facebook_user_id].delete('/')
  end
end