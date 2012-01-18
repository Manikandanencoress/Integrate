class User < ActiveRecord::Base
  has_many :orders
  has_many :page_visits

  has_many :shares
  has_many :likes, :through => :shares

  has_many :shares
  has_many :clips, :through => :shares

  has_many :shares
  has_many :quotes, :through => :shares

  validates :facebook_user_id, :uniqueness => true, :presence => true

  def self.find_or_create_from_fb_graph(fb_graph)
    if fb_graph.user
      find_or_initialize_by_facebook_user_id(fb_graph.user.identifier).tap do |user|
        user.set_user_attrs_from_fb(fb_graph) if user.new_record?
      end
    end
  end

  def self.export_to_csv(users)

    csv_string = CSV.generate do |csv|
      # header row
      csv << ["Name",
              "Facebook User ID",
              "Created At",
              "Email",
              "Birthday"
      ]

      users.each do |u|
        csv << [u.name,
                u.try(:facebook_user_id),
                u.created_at,
                u.email,
                u.birthday
        ]
      end
    end

  end


  def set_user_attrs_from_fb(fb_graph)
    fb_user = fb_graph.user.fetch
    self.name = fb_user.name
    self.gender = fb_user.gender
    self.email = fb_user.email
    self.birthday = fb_user.birthday
    self.country = fb_graph.data[:user][:country].try(:upcase)
    self.city, self.state = fb_user.location.name.to_s.split(",").map(&:strip) if fb_user.location
    self.save
  end

  def currently_rented_movies_for_studio(studio)
    studio.orders.where(:status => 'settled').where(:user_id => self.id).select { |o| !o.expired? }.map(&:movie)
  end

  def name_downcase
    self.try(:name).to_s.downcase
  end

end
