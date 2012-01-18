class AddAgeRestrictedToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :age_restricted, :boolean
  end

  def self.down
    remove_column :movies, :age_restricted
  end
end
