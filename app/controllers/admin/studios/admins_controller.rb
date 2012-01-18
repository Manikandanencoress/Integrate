class Admin::Studios::AdminsController < AdminController
  def index
    studio = Studio.find(params[:studio_id])
    @admins = studio.admins
    @invitations = studio.invitations.unredeemed
  end
end
