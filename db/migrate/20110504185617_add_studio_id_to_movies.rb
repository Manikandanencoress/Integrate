class AddStudioIdToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :studio_id, :integer
  end

  def self.down
    remove_column :movies, :studio_id
  end
end
