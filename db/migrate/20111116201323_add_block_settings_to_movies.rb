class AddBlockSettingsToMovies < ActiveRecord::Migration
  def self.up
    add_column  :movies, :top_clips_enabled, :boolean
    add_column  :movies, :top_quotes_enabled, :boolean
    add_column  :movies, :top_bestsellers_enabled, :boolean
  end

  def self.down
    remove_column  :movies, :top_clips_enabled
    remove_column  :movies, :top_quotes_enabled
    remove_column  :movies, :top_bestsellers_enabled
  end
end
