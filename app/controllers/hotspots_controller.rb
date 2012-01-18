class HotspotsController < InheritedResources::Base
  belongs_to :movie
  respond_to :json
  skip_before_filter :validate_geo_restriction
  actions :index, :show

  def create
    @movie = Movie.find(params[:movie_id])
    @studio = @movie.studio
    spot_params = params[:hot_spot]
    spot = @movie.hot_spots.create(spot_params)
    render :json => HotSpot.data_points(params[:movie_id]).select { |point| point[:marked_at] == spot.marked_at}.first
  end

  def index
    render :json => HotSpot.data_points(params[:movie_id])
  end

end
