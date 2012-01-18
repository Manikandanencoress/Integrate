class Admin < ActiveRecord::Base
  belongs_to :studio
  before_create :assign_studio_from_invitation, :if => :invitation

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :invitation, :foreign_key => :redeemer_id
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  def studio_admin?
    studio.present?
  end

  def milyoni_admin?
    !studio_admin?
  end

  private

  def assign_studio_from_invitation
    self.studio = invitation.studio
  end

end