class Admin::Studios::UsersController < AdminController

  def index
    @studio = Studio.find(params[:studio_id])
    @filter = Filter::StudioUser.new(@studio, params[:filter])
    @users = @filter.fetch_users!.order(:name)
    @counts = fetch_counts_from_filter(@filter)

    respond_to do |format|
      format.csv {
        render_csv User.export_to_csv @users
      }
      format.html
    end
  end

  def show
    @studio = Studio.find(params[:studio_id])
    @user = User.find(params[:id])
    @orders = @studio.orders.where(:user_id => @user)
  end

  protected

  def fetch_counts_from_filter(filter)
    @counts = filter.page_visit_count_users.inject({}) do |hash, user|
      hash[user.id] = {:page_visits => user.page_visits_count}
      hash
    end

    @counts = filter.orders_count_users.inject(@counts) do |hash, user|
      hash[user.id] ||= {}
      hash[user.id][:orders] = user.orders_count
      hash
    end
  end
end