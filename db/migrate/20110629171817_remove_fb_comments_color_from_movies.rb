class RemoveFbCommentsColorFromMovies < ActiveRecord::Migration
  def self.up
    remove_column :movies, :fb_comments_color
  end

  def self.down
    add_column :movies, :fb_comments_color, :string
  end
end
