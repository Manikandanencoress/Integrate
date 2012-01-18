class AddBrightcoveMovieIdToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :brightcove_movie_id, :string
  end

  def self.down
    remove_column :movies, :brightcove_movie_id
  end
end
