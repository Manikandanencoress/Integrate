class CreateGroupDiscounts < ActiveRecord::Migration
  def self.up
    create_table :group_discounts do |t|
      t.integer :order_id
      t.string :discount_key

      t.timestamps
    end
  end

  def self.down
    drop_table :group_discounts
  end
end
