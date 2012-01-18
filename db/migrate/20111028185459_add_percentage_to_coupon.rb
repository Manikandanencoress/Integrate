class AddPercentageToCoupon < ActiveRecord::Migration
  def self.up

    add_column :coupons, :percent, :integer, :limit => 3
  end

  def self.down
    remove_column :coupons, :percent
  end
end
