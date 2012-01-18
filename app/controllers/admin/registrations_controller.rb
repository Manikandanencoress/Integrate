class Admin::RegistrationsController < Devise::RegistrationsController
  rescue_from(ActiveRecord::RecordNotFound) { unauthorized_user_without_invite }
  layout 'admin'
  skip_before_filter :validate_geo_restriction

  def new
    invitation = fetch_invitation!
    @admin = Admin.new(:email => invitation.email)
    @admin.invitation = invitation
  end

  def create
    invitation = fetch_invitation!
    @admin = Admin.new(params[:admin])
    @admin.invitation = invitation
    if @admin.save
      sign_in(:admin, @admin)
      flash.notice = "Welcome! #{@admin.email}"
      if @admin.studio_admin?
        redirect_to admin_studio_path(@admin.studio)
      else
        redirect_to admin_studios_path
      end
    else
      render :action => 'new'
    end
  end

  protected

  def fetch_invitation!
    Invitation.unredeemed.find_by_token!(params[:token])
  end
  def unauthorized_user_without_invite
    redirect_to "http://google.com"
  end
end