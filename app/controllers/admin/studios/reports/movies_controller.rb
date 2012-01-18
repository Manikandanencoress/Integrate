class Admin::Studios::Reports::MoviesController < AdminController
  def show
    @filter = Filter::DateFilter.new(params[:filter])
    @studio = Studio.find(params[:studio_id])
    if params[:series]
      @reports = @studio.series.map do |series|
        series.report(@filter.date)
      end
    else
      @reports = @studio.titles.map do |movie|
        movie.report(@filter.date)
      end
    end
  end
end
