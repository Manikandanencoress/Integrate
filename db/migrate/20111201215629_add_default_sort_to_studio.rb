class AddDefaultSortToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :default_sort, :string
  end

  def self.down
    remove_column :studios, :default_sort
  end
end
