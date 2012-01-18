class Admin::UserDetailReportsController < ApplicationController
  layout "admin"
  skip_before_filter :validate_geo_restriction
  before_filter :authenticate_admin!
  inherit_resources
  actions :index
  
  def index
    whitelist_users = Order.find(:all,:select=>"DISTINCT user_id")
    @users = User.find(:all,:conditions => ["id NOT IN (?)",whitelist_users.map(&:user_id)])
  end
  
  def update_user_detail
    @user = User.find(params[:userid])
    respond_to do |format|
      format.js
    end
  end

end
