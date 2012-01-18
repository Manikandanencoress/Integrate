class CreatePaypals < ActiveRecord::Migration
  def self.up
    create_table :paypals do |t|
      t.string :token, :limit => 100
      t.string :payerid, :limit => 50
      t.string :status, :limit => 40
      t.integer :order_id

      t.timestamps
    end
    add_index :paypals, :order_id
  end

  def self.down
    drop_table :paypals
  end
end
