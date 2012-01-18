class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.string :title
      t.string :code
      t.string :comments
      t.datetime :expires_at
      t.integer :movie_id
      t.timestamps
    end

    add_index :coupons, :code
    add_index :coupons, :movie_id

  end

  def self.down
    drop_table :coupons
  end
end
