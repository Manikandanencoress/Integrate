class Admin::Studios::InvitationsController < AdminController
  inherit_resources
  actions :new, :destroy
  belongs_to :studio

  def index
    @invitations = @studio.invitations.unredeemed
  end

  def create
    @studio.invitations.create!(params[:invitation])
    redirect_to admin_studio_invitations_path(@studio)
  end
  
end