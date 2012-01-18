class Admin::Studios::Reports::TaxController < AdminController
  def show
    @studio = Studio.find(params[:studio_id])
    @orders = @studio.orders
  end
end