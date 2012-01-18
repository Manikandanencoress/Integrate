class AddNameToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :name, :string
  end

  def self.down
    remove_column :studios, :name
  end
end
