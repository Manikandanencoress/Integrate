class Filter::StudioUser < Filter
  attr_accessor :purchasers_only

  def initialize(studio, params)
    super(params)
    @studio = studio
    self.purchasers_only= @params[:purchasers_only]
  end

  def orders_count_users
    users_with_studio(:orders).where(:orders => {:status => [:refunded, :settled, :disputed]}).
        select("users.id, count(orders.id) as orders_count").group("users.id")
  end

  def page_visit_count_users
    users_with_studio(:page_visits).select("users.id, count(page_visits.id) as page_visits_count").group("users.id")
  end

  def fetch_users!
    @users = User.where(:id => studio_user_ids)
  end

  protected

  def purchasers_only= value
    @purchasers_only = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)
  end

  def users_with_studio(collection)
    User.where(collection => {:movies => {:studio_id => @studio.id}}).joins(collection => {:movie => :studio})
  end

  def studio_user_ids
    @user_ids ||= lambda do
      user_ids = orders_count_users.map(&:id)
      user_ids += page_visit_count_users.map(&:id) unless purchasers_only
      user_ids
    end.call
  end
end
