class Coupon < ActiveRecord::Base
  belongs_to :movie
  attr_accessor :expires

  validates_presence_of :code, :movie_id , :percent
  validates_uniqueness_of :code, :scope => :movie_id


  def price
    to_remove = (self.percent * 0.01) * self.movie.price
    self.movie.price - to_remove
  end

end
