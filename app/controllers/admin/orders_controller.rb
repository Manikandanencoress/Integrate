class Admin::OrdersController < AdminController
  # admin/movies/:movie_id/orders
  def index
    @movie = Movie.find(params[:movie_id])
    @orders = @movie.orders
    respond_to do |format|
        format.csv {
          render_csv Order.export_to_csv
        }
      format.html
    end
  end

  # admin/orders/:id?params
  def update
    @order = Order.find(params[:id])
    status = params[:order].delete(:status)
    @order.refund! if status == "refund"
    redirect_to request.referer
  end
end
