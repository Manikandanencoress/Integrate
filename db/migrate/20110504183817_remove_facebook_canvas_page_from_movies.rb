class RemoveFacebookCanvasPageFromMovies < ActiveRecord::Migration
  def self.up
    remove_column :movies, :facebook_canvas_page
  end

  def self.down
    add_column :movies, :facebook_canvas_page, :string
  end
end
