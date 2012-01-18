class PageVisit < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
  scope :for_purchase_page, where(:page => 'purchase')
  scope :from_time_range, lambda{|time_range| where(:created_at => time_range) }
  scope :for_watch_page, where(:page => 'watch')
  scope :from_today, lambda {
    utc_today_midnight = Time.now.beginning_of_day.utc
    where("created_at > ?", utc_today_midnight)
  }
  scope :before, lambda { |date| where('created_at <= ?', date) }
end
