class AddGroupDiscountEnable < ActiveRecord::Migration
  def self.up
    add_column :studios, :group_buy_enabled, :boolean
  end

  def self.down
    remove_column :studios, :group_buy_enabled
  end
end
