class AddLeftAt < ActiveRecord::Migration
  def self.up
    add_column :orders, :left_at, :integer
  end

  def self.down
    remove_column :orders, :left_at
  end
end
