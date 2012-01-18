class AddVideoLinks < ActiveRecord::Migration
  def self.up
    add_column :movies,:original_video_link, :string
    add_column :movies,:subtitled_video_link, :string
    add_column :movies,:dubbed_video_link, :string
  end

  def self.down
    remove_column :movies, :original_video_link
    remove_column :movies, :subtitled_video_link
    remove_column :movies, :dubbed_video_link
  end
end
