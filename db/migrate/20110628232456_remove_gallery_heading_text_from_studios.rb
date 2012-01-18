class RemoveGalleryHeadingTextFromStudios < ActiveRecord::Migration
  def self.up
    remove_column :brandings, :name
    remove_column :brandings, :gallery_text_color
  end

  def self.down
    add_column :brandings, :gallery_text_color, :string
    add_column :brandings, :name, :string
  end
end
