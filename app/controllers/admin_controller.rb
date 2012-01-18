
class AdminController < ApplicationController
  skip_before_filter :validate_geo_restriction
  before_filter :authenticate_admin!
  load_and_authorize_resource :studio

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_studio_path(current_admin.studio), :alert => exception.message
  end
  
  protected
  def current_ability
    @current_ability ||= Ability.new(current_admin)
  end
end