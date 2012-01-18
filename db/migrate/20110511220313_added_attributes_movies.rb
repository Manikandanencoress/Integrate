class AddedAttributesMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :button_color, :string
    add_column :movies, :popup_bk_color, :string
    add_column :movies, :thumb_popup_image, :string
    add_column :movies, :logo_popup_image, :string
  end

  def self.down
    remove_column :movies, :button_color
    remove_column :movies, :popup_bk_color
    remove_column :movies, :thumb_popup_image
    remove_column :movies, :logo_popup_image
  end
end
