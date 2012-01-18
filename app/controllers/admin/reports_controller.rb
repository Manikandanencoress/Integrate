class Admin::ReportsController < AdminController
  def show
    @movie = Movie.find(params[:movie_id])
    @report = @movie.report
  end
end