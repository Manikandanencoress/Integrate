class Order < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
  has_many :ip_addresses
  has_many :paypals

  has_one :redeem_discount
  has_one :group_discount

  scope :settled, where(:status => 'settled')
  scope :from_time_range, lambda { |time_range| where(:rented_at => time_range) }
  scope :ordered_today, lambda {
    utc_today_midnight = Time.now.change(:hour => 0, :min => 0, :sec => 0)
    where("rented_at > ?", utc_today_midnight)
  }
  scope :before, lambda { |date| where('rented_at <= ?', date) }

  after_create :set_flash_config_key, :series_pass_orders


  def self.export_to_csv
    orders = find(:all)

    csv_string = CSV.generate do |csv|
      # header row
      csv << ["Rented at",
              "Facebook user",
              "Facebook order",
              "Status",
              "Total credits",
              "Status",
              "Tax Amount",
              "Zip Code"]

      orders.each do |order|
        csv << [order.rented_at,
                order.user.try(:facebook_user_id),
                order.facebook_order_id,
                order.status,
                order.total_credits,
                order.status,
                order.tax_collected,
                order.zip_code]
      end
    end

  end

  def fb_popup_was_shown
    ie = IeIssue.find_by_movie_id_and_user_id movie_id, user_id
    ie.fb_popped_up? if ie
  end

  def log_ip(ip)
    ip_addresses.find_or_create_by_ip(ip)
  end

  def is_ip_ok?(ip)
    whitelisted_ips.include?(ip)
  end

  def expired?
    return false if status != 'settled'
    return true if movie.nil?
    expiration_time = rented_at + movie.rental_length.seconds
    expiration_time < Time.now
  end

  def settle!
    update_attributes! :status => 'settled', :rented_at => Time.now.utc
  end

  def dispute!
    update_attributes! :status => 'disputed'
  end

  def refund!
    raise "Can only refund disputed orders" unless status == 'disputed'
    facebook_app = FbGraph::Application.new(movie.studio.facebook_app_id, :secret => movie.studio.facebook_app_secret)
    facebook_access_token = facebook_app.get_access_token
    fb_order = FbGraph::Order.new(facebook_order_id, :access_token => facebook_access_token)

    begin
      update_attributes! :status => 'refunded' if (@status = fb_order.refunded!(:message => "Refunding an order", :refund_funding_source => nil))
    rescue FbGraph::NotFound
    end

    raise "Failed to refund facebook order" unless @status == true
  end

  def self.process_from_fb_order(fb_order)
    case fb_order.status
      when 'placed'
        fb_user = User.find_by_facebook_user_id!(fb_order.user_id)
        Order.create(:user => fb_user,
                     :facebook_order_id => fb_order.order_id,
                     :status => fb_order.status,
                     :movie_id =>fb_order.movie_id,
                     :total_credits => fb_order.total,
                     :zip_code => fb_order.zip_code,
                     :tax_collected => fb_order.tax_collected)
      when 'settled'
        order = Order.find_by_facebook_order_id(fb_order.order_id)
        order.settle!
        false # we don't want our callback to return anything
      when 'disputed'
        order = Order.find_by_facebook_order_id(fb_order.order_id)
        order.dispute!
        false
    end
  end

  def set_flash_config_key
    update_attribute(:flash_config_key, KeyGenerator.generate)
  end

  def series_pass_orders
    movie = Movie.find(movie_id) if movie_id
    if movie
      if movie.series
        if total_credits == movie.series.price
          movie.series.movies.each do |movie|
            new_order = self.clone
            new_order.movie_id = movie.id
            new_order.save
          end
        end
      end
    end
  end

  private

  def ip_limit
    movie.studio.max_ips_for_movie
  end

  def whitelisted_ips
    ip_addresses.limit(ip_limit).map(&:ip)
  end
end

class Order::FacebookOrder
  attr_accessor :status, :user_id, :order_id, :movie_id, :total, :zip_code, :tax_collected

  def initialize(order_details)
    @status = order_details['status'].try(:to_s)
    @order_id = order_details['order_id'].try(:to_s)
    @user_id = order_details['buyer'].try(:to_s)

    if @status == "placed"
      data = JSON.parse(order_details['items'].first['data'])
      @movie_id = data['movie_id']
      @total = data['cost'] + data['tax']
      @zip_code = data['zip_code']
      @tax_collected = data['tax']
    end
  end
end
