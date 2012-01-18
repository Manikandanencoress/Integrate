class SplitActionBoxPositionFieldsForMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :action_box_top, :string
    add_column :movies, :action_box_left, :string
    remove_column :movies, :action_box_position
  end

  def self.down
    remove_column :movies, :action_box_top
    remove_column :movies, :action_box_left
    add_column :movies, :action_box_position, :string
  end
end
