class Admin::SalesReportsController < ApplicationController
  layout "admin"
  skip_before_filter :validate_geo_restriction
  inherit_resources
  actions :index
  
  def index 
    if params[:format]
        @fromdate =  params[:from_date].to_date
        @todate = params[:to_date].to_date
        @studio_id= params[:studio_id]
        respond_to do |format|
          format.csv {
             export_to_csv(@fromdate,@todate,@studio_id)
          }
          format.html
        end

    elsif  params[:filter]
      @fromdate = Date.civil(params[:filter]["startdate(1i)"].to_i,
      params[:filter]["startdate(2i)"].to_i,
      params[:filter]["startdate(3i)"].to_i)
      @fromdate = @fromdate.to_date
      @todate = Date.civil(params[:filter]["enddate(1i)"].to_i,
      params[:filter]["enddate(2i)"].to_i,
      params[:filter]["enddate(3i)"].to_i)
      @todate = @todate.to_date
      
    else
      @fromdate = Order.find(:first).created_at
      @fromdate = @fromdate.to_date
      @todate = Time.now.to_date
    end
    if params[:studio] and params[:studio][:studio_id] != ""
        @studios = Studio.find(:all,:conditions=>["id=?",params[:studio][:studio_id]])
        @current_selected = params[:studio][:studio_id]
    else
         @studios = Studio.find(:all,:order=>"name")
         @current_selected=0
    end
    
  end
  
  def export_to_csv(fromdate,todate,studio_id)
    filename = "#{RAILS_ROOT}/public/movie_fan_count.csv"
    
    if studio_id and studio_id.to_i != 0 
      @studios = Studio.find(:all,:conditions=>["id=?",studio_id],:order=>"name")
    else
     @studios = Studio.find(:all,:order=>"name") 
    end

    csv_string = CSV.generate do |csv|
      csv << ["Movie Purchases for week of #{Date::ABBR_MONTHNAMES[@fromdate.month]} #{@fromdate.day}th #{@fromdate.year} to #{Date::ABBR_MONTHNAMES[@todate.month]} #{@todate.day}th #{@todate.year}"]
      csv << ["","","","","RENTALS","","DOLLARS","","VISITORS","","CONVERSION RATE",""]
      csv << ["Studio / Movie",
        "Fan Count",
        "Launch Date",
        "Price",
        "#{(fromdate).to_date.day.ordinalize} #{Date::ABBR_MONTHNAMES[(fromdate).to_date.month]} to #{todate.day.ordinalize} #{Date::ABBR_MONTHNAMES[(todate).to_date.month]}",
        "Cumulative Total",
        "#{(fromdate).to_date.day.ordinalize} #{Date::ABBR_MONTHNAMES[(fromdate).to_date.month]} to #{todate.day.ordinalize} #{Date::ABBR_MONTHNAMES[(todate).to_date.month]}",
        "Cumulative",
        "#{(fromdate).to_date.day.ordinalize} #{Date::ABBR_MONTHNAMES[(fromdate).to_date.month]} to #{todate.day.ordinalize} #{Date::ABBR_MONTHNAMES[(todate).to_date.month]}",
        "Cumulative Total",
        "#{(fromdate).to_date.day.ordinalize} #{Date::ABBR_MONTHNAMES[(fromdate).to_date.month]} to #{todate.day.ordinalize} #{Date::ABBR_MONTHNAMES[(todate).to_date.month]}",
        "Cumulative",
      ]
      @studios.each do |studio|
        studio.movies.each do |movie|
          if movie.studio_id !=nil and movie.facebook_fan_page_id != nil
            lastweek_sales = movie.movie_purchased_period(@fromdate,@todate)
            lastweek_visitors = movie.visitors_lastweek((@fromdate.to_date + 1.days) , @todate)
            sales = movie.movie_purchased_period(@fromdate.to_date + 1.days,@todate)
            cumulative = movie.movie_purchased 
            totalvisitors = movie.total_visitors 
            fan_count = 0
            
            CSV.foreach(filename, :quote_char => '"', :col_sep =>',', :row_sep =>:auto, :headers => true) do |row|
              fan_count =  row["fan_count"].to_i if row["movie_id"].to_i == movie.id
            end

            visitors_rate_cumulative = 0
            if lastweek_visitors.to_i > 0
            last_week_conversion_rate = format("%.2f",(sales* 100).to_f/lastweek_visitors .to_f)
            else
            last_week_conversion_rate = 0
            end

            if fan_count != nil
            visitors_rate_cumulative = (format("%.5f",(totalvisitors * 100).to_f/fan_count.to_f)).to_s if fan_count > 0
            end
            csv << [movie.studio.name + " / " + movie[:title],fan_count,movie[:created_at].to_date,"$" + ( movie[:price] / 10 ).to_s,sales,cumulative,"$" + (format("%.2f",(lastweek_sales * 3).to_f)).to_s ,"$" + (format("%.2f",(sales * 3).to_f)).to_s ,lastweek_visitors ,totalvisitors,(last_week_conversion_rate).to_s + "%" ,(format("%.2f",(cumulative * 100).to_f/totalvisitors.to_f)).to_s + "%" ]
            fan_count = 0
          end
        end
        end
    end

    file_name = 'Orders_' + Date.today.to_s + '.csv'
    
    send_data(csv_string,
    :type => 'text/csv; charset=utf-8; header=present',
    :filename => file_name)

  end

end