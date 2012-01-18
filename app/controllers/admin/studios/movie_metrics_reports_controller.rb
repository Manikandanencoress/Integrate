class Admin::Studios::MovieMetricsReportsController < ApplicationController
  skip_before_filter :validate_geo_restriction
  layout "admin"
  inherit_resources
  actions :index
  def index
    if !current_admin.studio.present?
      @studios = Studio.find(:all,:order=>"name")
    else
       @studios = Studio.find(:all,:conditions=>["id=?",current_admin.studio.id],:order=>"name")
    end

    @studio = Studio.find(params[:studio_id]) if params[:studio_id] != ""
    @studio = Studio.find(params[:studio][:id]) if params[:studio] and params[:studio][:id]!=""
    @current_selected = @studio.id
    @movies= Movie.find(:all,:conditions=>["studio_id=?",@studio.id],:order=>"title") if @studio and @studio.id!=nil 

    if  params[:movie] and params[:movie][:id]!="" and params[:submit] and params[:submit]=="Show"
      @movie = Movie.find(params[:movie][:id]) 
      @fromdate = Date.civil(params[:filter]["startdate(1i)"].to_i,
      params[:filter]["startdate(2i)"].to_i,
      params[:filter]["startdate(3i)"].to_i)
      @fromdate = @fromdate.to_date
      @todate = Date.civil(params[:filter]["enddate(1i)"].to_i,
      params[:filter]["enddate(2i)"].to_i,
      params[:filter]["enddate(3i)"].to_i)
      @todate = @todate.to_date
      @purchase_count = 0
      @watch_count = 0
      # (@fromdate..@todate).each do |date|
        # purchase_page=PageVisit.find(:all,:select => 'DISTINCT user_id',:conditions=>["movie_id=? and page='purchase' and date(created_at) = ? ",params[:movie][:id],date])
        # puts "purchase at #{date}"
        # puts purchase_page.inspect
        # @purchase_count += purchase_page.count
        # watch_page=PageVisit.find(:all,:select => 'DISTINCT user_id',:conditions=>["movie_id=? and page='watch' and date(created_at) = ? ",params[:movie][:id],date])
        # @watch_count += watch_page.count   
      # end
    end
  end

end
