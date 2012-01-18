class Like < ActiveRecord::Base
  belongs_to :movie

  has_many :shares
  has_many :users, :through => :shares

  def self.most_popular(max = 3)
    all(:order => "shares_count DESC", :limit => max)
  end


end
