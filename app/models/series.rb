class Series < ActiveRecord::Base
  has_many :movies
  belongs_to :studio

  def movie
    movies.select {|m| m.serial}.first
  end

  def titles
    movies.select {|m| !m.serial}
  end

  def as_json(options = {})
    {
        :id => id,
        :price => price,
        :enable_series_pass => enable_series_pass
    }
  end

  def report(date = Date.today)
    report = SeriesReport.new(self)
    report.generate
  end

  private

  class SeriesReport
    def initialize(series)
      hash = Hash.new
      @series = series
      @title_reports = @series.titles.collect {|title| title.report}
      @keys = @title_reports.first.keys
      @keys.collect {|k| hash.merge!({k.to_sym => 0}) }
      @series_report = hash
      [:name, :price, :todays_conversion, :cumulative_conversion].collect {|k| @keys.delete(k)}
    end


    def generate
      @title_reports.each do |report|
        @keys.each do |k|
          @series_report[k] = @series_report[k] + report[k]
        end
      end
      @series_report[:name] = @series.movie.title
      @series_report[:todays_visits].zero? ? 0 : @series_report[:todays_conversion] = @series_report[:todays_watches] / @series_report[:todays_visits].to_f
      @series_report[:cumulative_visits].zero? ? 0 : @series_report[:cumulative_conversion] = @series_report[:cumulative_watches] / @series_report[:cumulative_visits].to_f
      @series_report
    end

  end


end
