class AddFbCommentsColorBackToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :fb_comments_color, :string
  end

  def self.down
    remove_column :movies, :fb_comments_color
  end
end
