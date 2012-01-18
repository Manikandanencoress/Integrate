class Studio < ActiveRecord::Base

  PLAYERS = %w{warner brightcove milyoni}
  
  has_many :movies
  has_many :series
  has_many :invitations
  has_one :branding
  has_many :admins
  has_many :orders, :through => :movies

  validates_presence_of :facebook_canvas_page,
                        :help_text,
                        :privacy_policy_url,
                        :name

  validates_numericality_of :max_ips_for_movie

  before_create :brand_me

  acts_as_taggable_on :genres

  def genre_list
    genres.sort_by! { |i| i.name }.map(&:name)
  end

  def is_warner?
    player && player.include?("warner")
  end

  def is_brightcove?
    player && player.include?("brightcove")
  end

  def is_milyoni?
    player && player.include?("milyoni")
  end

  def has_paypal_setup
    paypal_api_user && paypal_api_password && paypal_api_signature ? true : false
  end

  def is_gratwick?
    name.include?("Gratwick")
  end

  def titles
    movies.select { |m| !m.serial }
  end

  def bestsellers
    reports, recommendation = [], []
    titles.each do |movie|
      reports << {:movie => movie, :orders => movie.report[:cumulative_orders]} if movie
    end
    reports.sort! { |a, b| a[:orders] <=> b[:orders] }
    3.times do
      report = reports.pop
      recommendation << report[:movie] unless report.nil?
    end
    recommendation
  end

  private

  def brand_me
    self.branding = Branding.new
  end
end