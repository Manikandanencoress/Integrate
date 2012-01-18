class AddFacebookFieldsToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :facebook_app_id, :string
    add_column :movies, :facebook_canvas_url, :string
  end

  def self.down
    remove_column :movies, :facebook_canvas_url
    remove_column :movies, :facebook_app_id
  end
end
