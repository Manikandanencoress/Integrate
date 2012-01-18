class CreateCouponRedeemers < ActiveRecord::Migration
  def self.up
    create_table :coupon_redeemers do |t|
      t.integer :order_id
      t.integer :coupon_id

      t.timestamps
    end

    add_index :coupon_redeemers, :order_id
    add_index :coupon_redeemers, :coupon_id

  end

  def self.down
    drop_table :coupon_redeemers
  end
end
