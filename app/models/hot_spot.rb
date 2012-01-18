class HotSpot < ActiveRecord::Base

  HEIGHT_OF_THE_HEAT_MAP = 34

  def self.data_points(movie_id)
    dimension_map = []
    spots = HotSpot.find_all_by_movie_id(movie_id).collect(&:marked_at)
    hash_map = spots.inject(Hash.new(0)) { |sums, x| sums[x] += 1; sums }

    highest_count = hash_map.values.max

    hash_map.each do |k, v|
      height = (v*HEIGHT_OF_THE_HEAT_MAP)/highest_count
      dimension_map << {:marked_at => k, :height => height, :top => self.measure_it(height)}
    end
    dimension_map
  end

  private

  def self.measure_it height
     HEIGHT_OF_THE_HEAT_MAP - height - 6
  end

end
