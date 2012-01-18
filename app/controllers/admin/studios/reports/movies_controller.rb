class Admin::Studios::Reports::MoviesController < AdminController
  def show
    @filter = Filter::DateFilter.new(params[:filter])
    if !current_admin.studio.present?
      @studios = Studio.find(:all,:order=>"name")
    else
      @studios = Studio.find(:all,:conditions=>["id=?",params[:studio_id]])
    end
    @studio = Studio.find(params[:studio][:id]) if params[:studio] and params[:studio][:id]!=""
    
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
