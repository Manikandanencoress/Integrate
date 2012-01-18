class Admin::MoviesController < AdminController
  inherit_resources
  belongs_to :studio
  layout "admin"


  def new
    new! do
      @series = true if params[:series]
    end
  end
  
  def promotions
    @studio = Studio.find params[:studio_id]
    @movie = Movie.find params[:movie_id]
    @coupons = Coupon.where(:movie_id => params[:movie_id]).
        paginate(:page => params[:page], :per_page => 10).
        order('id DESC')
  end

  def wysiwyg_update

    @movie = Movie.find params[:id]

    @movie.update_attributes "wysiwyg_#{params[:kind]}_x".to_s => params[:x],
                             "wysiwyg_#{params[:kind]}_y".to_s => params[:y]

    if @movie
      code = '200'
      message = 'ok'
    else
      code = '403'
      message = @movie.errors.first.join(" ")
    end

    render :json => @movie.as_json.merge({:status=> code, :message => message}),
           :status => code
  end

  def preview
    @studio = Studio.find params[:studio_id]
    @movie = Movie.find params[:movie_id]
  end

  def show
    show! do
      @restrict_age = false
      @show_facebook_feed_dialog = false
      @ip_can_watch_movie = true
    end
  end

end