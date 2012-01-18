class AddGalleryTextColorToBrandings < ActiveRecord::Migration
  def self.up
    add_column :brandings, :gallery_text_color, :string
  end

  def self.down
    remove_column :brandings, :gallery_text_color
  end
end
