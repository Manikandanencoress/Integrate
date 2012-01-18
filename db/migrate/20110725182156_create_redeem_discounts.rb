class CreateRedeemDiscounts < ActiveRecord::Migration
  def self.up
    create_table :redeem_discounts do |t|
      t.integer :order_id
      t.integer :group_discount_id

      t.timestamps
    end
  end

  def self.down
    drop_table :redeem_discounts
  end
end
