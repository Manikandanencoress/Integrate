class AddSplashImageUrlToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :splash_image_url, :string
  end

  def self.down
    remove_column :movies, :splash_image_url
  end
end
