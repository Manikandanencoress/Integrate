class Movie < ActiveRecord::Base

  validates_presence_of :price,
                        :studio,
                        :font_color_help,
                        :popup_bk_color_1,
                        :popup_bk_color_2,
                        :button_color_gradient_1,
                        :button_color_gradient_2,
                        :feed_dialog_name,
                        :feed_dialog_link,
                        :feed_dialog_caption


  validates_presence_of :video_file_path,
                        :cdn_path,
                        :if => Proc.new { |movie| movie.studio && !movie.studio.series_enabled && movie.studio.is_warner? }

  validates_presence_of :brightcove_movie_id, :if => Proc.new { |movie| movie.studio && !movie.studio.series_enabled && movie.studio.is_brightcove? }

  validates :fb_comments_color, :inclusion => {:in => ['light', 'dark']}

  belongs_to :studio

  belongs_to :series

  has_many :orders
  has_many :page_visits
  has_one :skin
  has_many :comments
  has_many :coupons

  has_many :likes
  has_many :quotes
  has_many :hot_spots
  has_many :streams
  has_many :movie_metrics_reports

  before_create :skin_me
  after_create :serialize_it
  after_update :serialize_it

  after_update :curl_the_linter

  validate :released_movie_is_complete, :on => :update, :if => :released?

  acts_as_taggable_on :genres

  scope :viewable_for_user, lambda { |user|
    unless Sumuru::Application.config.whitelisted_facebook_ids.include?(user)
      where(:released => true)
    end
  }

  def facebook_fan_page_url= fan_page
    self[:facebook_fan_page_url]=fan_page

    case fan_page.to_s
      when /https?:\/\/www.facebook.com\/pages\/(?:.*)\/(\w+)/
        page_id = $1
      when /https?:\/\/www.facebook.com\/(\w+)/
        page_id = FbGraph::Page.new($1).fetch.identifier
      else
        page_id = nil
    end

    self[:facebook_fan_page_id] = page_id
  end

  def facebook_redirect_uri
    "#{self.studio.facebook_canvas_page}movies/#{id}"
  end

  def media_path
    WbTokenGenerator::TokenGenerator.generate(cdn_path, video_file_path)
  end

  def viewable_for_user?(user)
    released? || Sumuru::Application.config.whitelisted_facebook_ids.include?(user)
  end

  def report(date = Date.today)
    last_cumulative_day = date.end_of_day
    single_day_range = date.beginning_of_day..last_cumulative_day
    {
        :name => title,
        :price => price,

        :todays_orders => orders.settled.from_time_range(single_day_range).count,
        :todays_visits => page_visits.for_purchase_page.from_time_range(single_day_range).count,
        :todays_watches => page_visits.for_watch_page.from_time_range(single_day_range).count,
        :todays_revenue => orders.settled.from_time_range(single_day_range).sum(:total_credits),
        :todays_conversion => conversion_rate(:time_range => single_day_range),

        :cumulative_visits => page_visits.for_purchase_page.before(last_cumulative_day).count,
        :cumulative_orders => orders.settled.before(last_cumulative_day).count,
        :cumulative_watches => page_visits.for_watch_page.before(last_cumulative_day).count,
        :cumulative_revenue => orders.settled.before(last_cumulative_day).sum(:total_credits),
        :cumulative_conversion => conversion_rate(:before => last_cumulative_day)
    }
  end

  def active_orders_for(user)
#    TODO: refactor this into an expires_at column
    orders.where(:user_id => user.id, :status => 'settled').select { |o| !o.expired? }
  end

  def twitter_share_text
    Mustache.render(self[:twitter_share_text], as_json)
  end

  def facebook_share_text
    Mustache.render(self[:facebook_share_text], self.as_json)
  end

  def generate_discount_link
    if discount_redirect_link
      discount_redirect_link + "?discount_key=#{KeyGenerator.generate}"
    else
      "no-link"
    end
    # need to remove this later
    #"https://apps.facebook.com/universalplayer/movies/1" + "?discount_key=#{KeyGenerator.generate}"
  end

  def as_json(options = {})
    {
        :id => id,
        :studio_id => studio.id,
        :feed_dialog_link => (feed_dialog_link || facebook_redirect_uri),
        :feed_dialog_name => feed_dialog_name,
        :feed_dialog_caption => feed_dialog_caption,
        :title => title,
        :studio => studio.name,
        :price => price,
        :link => facebook_redirect_uri,
        :facebook_fan_page_url => facebook_fan_page_url,
        :original_video_link => original_video_link,
        :subtitled_video_link => subtitled_video_link,
        :dubbed_video_link => dubbed_video_link
    }
  end

  def restricted_for?(user)
    age_restricted? && user.birthday && user.birthday > 17.years.ago.to_date
  end

  def encoded_title
    URI.escape title
  end


  def fb_comments_color
    self[:fb_comments_color] ||= 'light'
  end

  def complete?
    skin.complete?
  end

  def genre
    @genre ||= genres.try(:first).try(:name)
  end

  def genre=(genre_string)
    @genre = self.genre_list= genre_string #acts_as_taggable_on api
  end

  def paypal_price
    add_up = (price * 10)
    add_up.to_i
  end

  def paypal_price_with_tax(tax = 0)
    #add_up = (price * 10) + (tax * 100)
    #add_up.to_i
    price.to_i
  end

  def self.search(search, series_id, studio_id)
    if !search.blank?
      result_set = []
      search_results = where('title LIKE ? AND studio_id = ?', "%#{search}%", studio_id)
      search_results.collect { |m| result_set<< m if !m.serial }
      return result_set
    else
      Series.find(series_id).titles
    end
  end

  def series *arg
    if arg[0]
      Series.find(series_id) if serial
    else
      (Series.find(series_id) unless series_id.nil?) unless serial
    end
  end

  def recommended_movies
    reports, recommendation = [], []
    movies_with_same_genre = studio.titles.collect { |title| title if title.genre == genre }
    movies_with_same_genre.each do |movie|
      reports << {:movie => movie, :orders => movie.report[:cumulative_orders]} if movie
    end
    reports.sort! { |a, b| a[:orders] <=> b[:orders] }
    3.times do
      report = reports.pop
      recommendation << report[:movie] unless report.nil?
    end
    recommendation.count == 3 ? recommendation : studio.bestsellers
  end

  # Code Added for Sales report start here

  def movie_purchased
    
     return Order.count(:conditions=>["movie_id = ? AND status = ?", self.id,"settled"])
  end
  def movie_purchased_period(start_date,end_date)
   
     return Order.count(:conditions=>["movie_id = ? AND status= ? AND updated_at >= ? AND updated_at <= ?",self.id,"settled",start_date,end_date])
   end
  def visitors_lastweek(fromdate,todate)
   
    return PageVisit.count(:conditions=>["movie_id = ? AND updated_at >= ? AND updated_at <= ?",self.id,fromdate,todate])
  end
   def total_visitors
    
    return PageVisit.count(:conditions=>["movie_id = ?",self.id])
  end
  # Code Added for Sales report end here

  private

  def curl_the_linter
    `curl #{try(:linter_url)}` if linter_url
  end

  def released_movie_is_complete
    if complete?
      true
    else
      errors.add(:released, "Movie must be complete to be released.")
    end
  end

  def skin_me
    self.skin = Skin.new
  end

  def serialize_it
    if self.serial? and (self.series_id == 0 || self.series_id == nil)
      series = Series.create
      self.update_attribute(:series_id, series.id)
      series.update_attribute(:studio_id, studio_id)
    end
  end

  def conversion_rate(options={})
    visits = page_visits.for_purchase_page
    settled_orders = orders.settled

    if options[:before]
      purchase_page_visits_count = visits.before(options[:before]).count
      settled_orders_count = settled_orders.before(options[:before]).count
    elsif options[:time_range]
      purchase_page_visits_count = visits.from_time_range(options[:time_range]).count
      settled_orders_count = settled_orders.from_time_range(options[:time_range]).count
    else
      purchase_page_visits_count = visits.count
      settled_orders_count = settled_orders.count
    end

    return 0 if purchase_page_visits_count.zero?
    settled_orders_count / purchase_page_visits_count.to_f
  end
end