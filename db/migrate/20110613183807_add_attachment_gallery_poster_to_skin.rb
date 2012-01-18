class AddAttachmentGalleryPosterToSkin < ActiveRecord::Migration
  def self.up
    add_column :skins, :gallery_poster_file_name, :string
    add_column :skins, :gallery_poster_content_type, :string
    add_column :skins, :gallery_poster_file_size, :integer
    add_column :skins, :gallery_poster_updated_at, :datetime
  end

  def self.down
    remove_column :skins, :gallery_poster_file_name
    remove_column :skins, :gallery_poster_content_type
    remove_column :skins, :gallery_poster_file_size
    remove_column :skins, :gallery_poster_updated_at
  end
end
