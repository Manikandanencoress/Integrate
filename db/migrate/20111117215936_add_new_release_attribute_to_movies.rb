class AddNewReleaseAttributeToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :new_release, :boolean
  end

  def self.down
    remove_column :movies, :new_release
  end
end
