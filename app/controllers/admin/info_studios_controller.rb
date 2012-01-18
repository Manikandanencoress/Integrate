class Admin::InfoStudiosController < ApplicationController
  layout "admin"
  skip_before_filter :validate_geo_restriction
  inherit_resources
  actions :index
  
  def index
    puts "index"
    puts params.inspect
    @studio = Studio.find(current_admin.studio.id) unless current_admin.blank?
  end

end