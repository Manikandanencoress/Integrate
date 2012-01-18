class AddSecondColorFieldsToMovie < ActiveRecord::Migration
  def self.up
    rename_column :movies, :button_color_gradient, :button_color_gradient_1
    add_column :movies, :button_color_gradient_2, :string

    rename_column :movies, :popup_bk_color, :popup_bk_color_1
    add_column :movies, :popup_bk_color_2, :string
  end

  def self.down
    remove_column :movies, :button_color_gradient_2
    rename_column :movies, :button_color_gradient_1, :button_color_gradient

    remove_column :movies, :popup_bk_color_2
    rename_column :movies, :popup_bk_color_1, :popup_bk_color
  end
end
