class AddPosterUrlToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :poster_url, :string
  end

  def self.down
    remove_column :movies, :poster_url
  end
end
