require 'rubygems'
require 'pg'
require 'active_record'
require 'action_mailer'
require 'mail'
require 'csv'
require 'fb_graph'
require 'fileutils'
desc "This task is called by the Heroku cron add-on : Sales report fan count CSV creation"
task :cron => :environment do
  
    filename = "#{RAILS_ROOT}/public/movie_fan_count.csv"
    studios = Studio.find(:all)
    studio_name = ""
    i=2
    CSV.open(filename, 'wb',:col_sep=>',') do |csv|
        # header row
        csv << ['id','movie_id' , 'fan_count']
        i=1
        studios.each do |studio|
          studio_name = studio.name
          movies = Movie.find(:all,:conditions=>["studio_id=?",studio.id],:order=>"studio_id ASC , id ASC")
          movies.each do |movie|
            fan_count = 0
            fan_count = fan_count(movie) if movie.facebook_fan_page_id != nil
            csv << [ i, movie.id, fan_count.to_s]
          i+=1
          end
        end
    end
  
end

task :movie_metrics_reports => :environment do
  #@myfacebook ||= FbGraph::Auth.new('196115547129805',
  #                                  'f24e25a7ee08c01d9c950c617612a829',
  #                                 :scope => [:read_insights])
  ('2011-05-16'.to_date..'2011-11-14'.to_date).each do |date|
    @metrics = FbGraph::Query.new("SELECT value FROM insights WHERE object_id=161604803891265 AND metric='page_views_unique' AND end_time=end_time_date('#{date}') AND period=period('day')").fetch('AAACyXbWFh80BABkFYsHYbdl85IDiET756G1ZASj2ZAx1SFJgmFAZAQtshhNW3EZCLvmNkiuZBZCcqxvHZB1erTj8LZBwZCmoQjzX88LkxtVZBr2gZDZD')
    viewvalue = 0
    @metrics.each do |x|
      viewvalue = x["value"]
    end
    @metrics = FbGraph::Query.new("SELECT value FROM insights WHERE object_id=161604803891265 AND metric='page_like_adds_unique' AND end_time=end_time_date('#{date}') AND period=period('day')").fetch('AAACyXbWFh80BABkFYsHYbdl85IDiET756G1ZASj2ZAx1SFJgmFAZAQtshhNW3EZCLvmNkiuZBZCcqxvHZB1erTj8LZBwZCmoQjzX88LkxtVZBr2gZDZD')
    likevalue = 0
    @metrics.each do |x|
      likevalue = x["value"]
    end
     movie_metrics_reports = MovieMetricsReport.create(:date=>date,:page_view_unique=>viewvalue,:movie_id_id=>107,:page_like=>likevalue) 
  end
end

def fan_count(movie)
  begin
    my_app = FbGraph::Application.new(movie.studio.facebook_app_id)  
    acc_tok = my_app.get_access_token(movie.studio.facebook_app_secret)
    page = FbGraph::Page.fetch(movie.facebook_fan_page_id)
    return page.like_count
  rescue Exception => e
  end
end
