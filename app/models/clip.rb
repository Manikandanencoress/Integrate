class Clip < ActiveRecord::Base

  belongs_to :movie 

  has_many :shares
  has_many :users, :through => :shares

  def self.most_pop_by_movie(movie_id, max = 3)
    where(:movie_id => movie_id).order("shares_count DESC").limit(max)
  end
  
end
