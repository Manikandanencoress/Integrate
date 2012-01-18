class Admin::AdminReportsController < ApplicationController
  layout "admin"
  skip_before_filter :validate_geo_restriction
  inherit_resources
  actions :index
  def index
    @studios = Studio.find(:all, :order=>"name")
  end

  def update_movie_list
    @movies = Movie.find(:all,:conditions => ["studio_id = ?", params[:id]])
    respond_to do |format|
      format.js
    end
 end
  
  def update_user_list
    if params[:movieid]
      @orders = Order.find(:all,:select=>"DISTINCT user_id",:conditions => ["movie_id = ? AND status= ?",params[:movieid],'settled'])
    else
      @purchasedmovies = Order.find(:all,:select=>"DISTINCT movie_id",:conditions => ["user_id = ? AND status= ?",params[:userid],'settled'])
    end
    respond_to do |format|
      format.js
    end
  end
end