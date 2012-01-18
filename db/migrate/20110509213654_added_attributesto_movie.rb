class AddedAttributestoMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :background_purchase_image_url, :string
    add_column :movies, :background_watch_image_url, :string
    add_column :movies, :share_fb_link, :string
    add_column :movies, :share_twitter_link, :string
    add_column :movies, :font_color_help, :string
  end

  def self.down
    remove_column :movies, :background_purchase_image_url
    remove_column :movies, :background_watch_image_url
    remove_column :movies, :share_fb_link
    remove_column :movies, :share_twitter_link
    remove_column :movies, :font_color_help
  end
end
