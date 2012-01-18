class RemoveUnusedStyleColumnsFromMovies < ActiveRecord::Migration

  def self.up
    remove_column :movies, :button_color_main if column_exists? :movies, :button_color_main, :string
    remove_column :movies, :button_color  if column_exists? :movies, :button_color, :string
  end

  def self.down
    add_column :movies, :button_color_main, :string unless column_exists? :movies, :button_color_main, :string
    add_column :movies, :button_color, :string unless column_exists? :movies, :button_color, :string
  end
end
