class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :facebook_order_id
      t.string :facebook_user_id
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
