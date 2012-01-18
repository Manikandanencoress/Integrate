class Admin::Studios::AdminsController < AdminController
  def index
    studio = Studio.find(params[:studio_id])
    @admins = studio.admins
  end
end