class MoreMovieAttributes < ActiveRecord::Migration
  def self.up
    add_column :movies, :director, :string
    add_column :movies, :lead_actors, :string
    add_column :movies, :year_released, :datetime
    add_column :movies, :MPAA_rating, :string, :limit => 10
    add_column :movies, :running_time, :string, :limit => 10
  end

  def self.down
    remove_column :movies, :director
    remove_column :movies, :lead_actors
    remove_column :movies, :year_released
    remove_column :movies, :MPAA_rating
    remove_column :movies, :running_time
  end

end