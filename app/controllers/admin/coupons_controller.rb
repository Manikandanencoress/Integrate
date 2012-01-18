class Admin::CouponsController < AdminController
  inherit_resources
  actions :show, :update, :edit, :new

  belongs_to :studio
  belongs_to :movie, :singleton => true

  def new
    @coupon = Coupon.new
    @coupon.movie_id = params[:movie_id]
  end

  def create
    params[:coupon][:expires_at] = params[:coupon][:expires]

    puts "****** params[:coupon][:expires_at] ********"
    puts params[:coupon][:expires_at]

    @coupon = Coupon.create(params[:coupon])

    if @coupon.id
      flash[:notice] = "Coupon created!"
      redirect_to admin_studio_movie_promotions_path(@coupon.movie.studio_id, @coupon.movie_id)
    else
      flash[:notice] = "Errors"
      render :action => 'new'
    end
  end


  def update

    @coupon = Coupon.find params[:id]
    params[:coupon][:expires_at] = params[:coupon][:expires]

    puts "****** params[:coupon][:expires_at] ********"
    puts params[:coupon][:expires_at]


    if @coupon.update_attributes(params[:coupon])
      flash[:notice] = "Coupon Updated!"
      redirect_to admin_studio_movie_promotions_path(@coupon.movie.studio_id, @coupon.movie_id)
    else
      flash[:notice] = "Errors"
      render :action => 'new'
    end
  end

  def index
    @studio = Studio.find params[:studio_id]
    @movie = Movie.find params[:movie_id]
    @coupon = @movie.coupons
  end

  def edit
    @studio = Studio.find params[:studio_id]
    @movie = Movie.find params[:movie_id]
    @coupon = Coupon.find params[:id]
  end
end