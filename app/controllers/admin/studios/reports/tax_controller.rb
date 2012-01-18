class Admin::Studios::Reports::TaxController < AdminController
  def show
    if !current_admin.studio.present?
      @studios = Studio.find(:all,:order=>"name")
    else
      @studio = Studio.find(params[:studio_id])
    end
    @studio = Studio.find(params[:studio][:id]) if params[:studio] and params[:studio][:id]!=""
    @orders = @studio.orders
    @current_selected = @studio.id
  end
end