class Admin::SeriesController < AdminController

  def index
    @studio = Studio.find(params[:studio_id])
    @series = @studio.series.collect(&:movie).compact
  end

  def show
    @series = Series.find(params[:id])
    @movie = @series.movie
    @studio = @movie.studio
    @titles = @series.titles.sort{|a,b| a.position.nil? ? 1 : (b.position.nil? ? -1 : a.position <=> b.position)}      #(&:position)
  end

  def search
    @titles = Movie.search(params[:search].titlecase, params[:series_id], params[:studio_id])

    respond_to do |format|
      format.js
    end
  end

  def edit
    @series = Series.find(params[:id])
    @movie = @series.movie
    @studio = @series.movie.studio
  end

  def update
    if params[:series]
       Series.find(params[:id]).update_attributes(params[:series])
      else
    if params[:positions] == "true"
      position_counter = 2 #1 is always for the series movie object.
      params[:ids].each do |id|
        movie = Movie.find(id.to_i)
        movie.update_attribute(:position, position_counter)
        position_counter = position_counter + 1
      end
    else
      series = Series.find(params[:id])
      title = Movie.find(params[:title_to_add])
      title.update_attribute(:series_id, series.id)
    end
    end
    redirect_to :back, :notice => "Successfully Updated!"
  end

  def destroy
    title = Movie.find(params[:title_to_remove])
    title.update_attribute(:series_id, nil)
    redirect_to :back
  end

end
