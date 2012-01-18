class Admin::InvitationsController < AdminController
  inherit_resources
  actions :new, :create, :destroy

  def index
    @invitations = Invitation.unredeemed
  end

  def show
    redirect_to admin_invitations_path, :flash => flash
  end

  def create
    create!(:notice => "Email Sent")
  end
end