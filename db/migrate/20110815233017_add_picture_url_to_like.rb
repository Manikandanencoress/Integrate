class AddPictureUrlToLike < ActiveRecord::Migration
  def self.up
    add_column :likes, :picture_url, :string
  end

  def self.down
    remove_column :likes, :picture_url
  end
end
