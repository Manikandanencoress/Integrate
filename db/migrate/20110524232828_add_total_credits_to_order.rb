class AddTotalCreditsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :total_credits, :integer
  end

  def self.down
    remove_column :orders, :total_credits
  end
end
