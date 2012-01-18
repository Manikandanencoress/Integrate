class Invitation < ActiveRecord::Base
  before_validation :generate_token, :on => :create
  belongs_to :studio
  belongs_to :redeemer, :class_name => "Admin"
  scope :unredeemed, where(:redeemer_id => nil)

  after_create :send_email

  validates :email, :presence => true

  validates :token,
            :uniqueness => true,
            :presence => true

  before_destroy ->{raise "can't delete an invitation that's already been redeemed"}, :if => :redeemed?

  def redeemed?
    !!redeemer_id
  end

  protected

  def generate_token
    self.token= Digest::MD5.hexdigest( "#{Time.now.to_i}#{Time.now.usec} Milyoni Invitation #{self.object_id} #{rand(100)}" )
  end

  def send_email
    InvitationMailer.invite(self).deliver!
  end
end
