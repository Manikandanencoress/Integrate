class AddFeedDialogAttributesToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :feed_dialog_link, :string
    add_column :movies, :feed_dialog_image, :string
    add_column :movies, :feed_dialog_name, :string
    add_column :movies, :feed_dialog_caption, :string
    add_column :movies, :feed_dialog_desc, :string
  end

  def self.down
    remove_column :movies, :feed_dialog_desc
    remove_column :movies, :feed_dialog_caption
    remove_column :movies, :feed_dialog_name
    remove_column :movies, :feed_dialog_image
    remove_column :movies, :feed_dialog_link
  end
end
