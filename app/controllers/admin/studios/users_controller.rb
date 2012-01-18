class Admin::Studios::UsersController < AdminController

  def index
    if params[:filter1]
      @fromdate = Date.civil(params[:filter1]["startdate(1i)"].to_i, params[:filter1]["startdate(2i)"].to_i, params[:filter1]["startdate(3i)"].to_i).to_date
      @todate = Date.civil(params[:filter1]["enddate(1i)"].to_i, params[:filter1]["enddate(2i)"].to_i, params[:filter1]["enddate(3i)"].to_i).to_date
    else
      @fromdate = Time.now - 7.days 
      @fromdate = @fromdate .to_date
      @todate = Time.now.to_date
    end
    
    if !current_admin.studio.present?
      @studios = Studio.find(:all,:order=>"name")
    else
      @studios = Studio.find(:all,:conditions=>["id=?",params[:studio_id]])
    end
    
    @studio = Studio.find(params[:studio][:id]) if params[:studio] and params[:studio][:id]!=""
    @movies= Movie.find(:all,:conditions=>["studio_id=?",@studio.id],:order=>"title") 
    if params[:movie] and params[:movie][:id]!=""
      @current_selected = params[:movie][:id] 
      @movie= Movie.find(params[:movie][:id]) if @current_selected.to_i > 0
    end
    if params[:flag] and params[:flag]=="export"
      @fromdate = params[:fromdate]
      @todate = params[:todate]
    end
    #@filter = Filter::StudioUser.new(@studio, params[:filter])
    @filter = Filter::StudioUser.new(@studio, @movie,@fromdate,@todate, params[:filter])
    @users = @filter.fetch_users!.order(:name)
    @counts = fetch_counts_from_filter(@filter)
    
    respond_to do |format|
      format.csv {
        render_csv User.export_to_csv(@users,@counts)
      }
      format.html
    end
  end

  def show
    @studio = Studio.find(params[:studio_id])
    @studio = Studio.find(params[:studio][:id]) if params[:studio] and params[:studio][:id]!=""
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
