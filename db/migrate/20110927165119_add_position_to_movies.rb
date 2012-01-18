class AddPositionToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :position, :integer
    add_column :movies, :serial, :boolean
  end

  def self.down
    remove_column :movies, :position
    remove_column :movies, :serial
  end
end
