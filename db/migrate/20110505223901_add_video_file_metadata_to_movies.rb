class AddVideoFileMetadataToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :cdn_path, :string
    add_column :movies, :video_file_path, :string
  end

  def self.down
    remove_column :movies, :video_file_path
    remove_column :movies, :cdn_path
  end
end
