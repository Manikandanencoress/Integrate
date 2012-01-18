class AddGalleryFooterTextBox < ActiveRecord::Migration
  def self.up
    add_column :studios, :gallery_footer_box, :text
  end

  def self.down
    remove_column :studios, :gallery_footer_box
  end
end