class AddGalleryHeaderBox < ActiveRecord::Migration
  def self.up
    add_column :studios, :gallery_header_box, :text
  end

  def self.down
    remove_column :studios, :gallery_header_box
  end
end
