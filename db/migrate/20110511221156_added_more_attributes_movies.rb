class AddedMoreAttributesMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :button_color_main, :string
    add_column :movies, :button_color_gradient, :string
  end

  def self.down
    remove_column :movies, :button_color_main
    remove_column :movies, :button_color_gradient
  end
end
