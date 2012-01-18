class AddActionBoxToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :action_box_position, :string, :default => "position: absolute; left: 68px; top: 500px; width: 310px;"
  end

  def self.down
    remove_column :movies, :action_box_position
  end
end
