class MoveFacebookAppIdFromMovieIntoStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :facebook_app_id, :string
    remove_column :movies, :facebook_app_id
  end

  def self.down
    remove_column :studios, :facebook_app_id
    add_column :movies, :facebook_app_id, :string
  end
end
