class AddLikeBoxAttributesToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :like_box_top, :integer
    add_column :movies, :like_box_left, :integer
  end

  def self.down
    remove_column :movies, :like_box_left
    remove_column :movies, :like_box_top
  end
end
