class RenameFacebookCanvasUrlToFacebookCanvasPage < ActiveRecord::Migration
  def self.up
    rename_column :movies, :facebook_canvas_url, :facebook_canvas_page
  end

  def self.down
    rename_column :movies, :facebook_canvas_page, :facebook_canvas_page
  end
end
