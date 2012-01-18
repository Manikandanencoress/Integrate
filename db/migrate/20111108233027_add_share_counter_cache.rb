class AddShareCounterCache < ActiveRecord::Migration

  def self.up
    add_column :likes, :shares_count, :integer, :limit => 6, :default => 0
    add_column :clips, :shares_count, :integer, :limit => 6, :default => 0
    add_column :quotes, :shares_count, :integer, :limit => 6, :default => 0
  end

  def self.down
    remove_column :likes, :shares_count
    remove_column :clips, :shares_count
    remove_column :quotes, :shares_count
  end

end