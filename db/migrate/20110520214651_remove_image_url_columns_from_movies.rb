class RemoveImageUrlColumnsFromMovies < ActiveRecord::Migration
  def self.up
    remove_column :movies, :poster_url
    remove_column :movies, :purchase_bg_url
    remove_column :movies, :watch_bg_url
    remove_column :movies, :splash_image_url
    remove_column :movies, :thumb_popup_image
    remove_column :movies, :logo_popup_image
    remove_column :movies, :pay_dialog_image
    remove_column :movies, :feed_dialog_image
  end

  def self.down
    add_column :movies, :feed_dialog_image, :string
    add_column :movies, :pay_dialog_image, :string
    add_column :movies, :logo_popup_image, :string
    add_column :movies, :thumb_popup_image, :string
    add_column :movies, :splash_image_url, :string
    add_column :movies, :watch_bg_url, :string
    add_column :movies, :purchase_bg_url, :string
    add_column :movies, :poster_url, :string
  end
end
