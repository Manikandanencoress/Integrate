class AddReleasedToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :released, :boolean
  end

  def self.down
    remove_column :movies, :released
  end
end
