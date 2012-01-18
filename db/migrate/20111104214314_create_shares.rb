class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :clip_id
      t.integer :like_id
      t.integer :quote_id
      t.integer :user_id

      t.timestamps
    end

    add_index :shares, :clip_id
    add_index :shares, :like_id
    add_index :shares, :quote_id
    add_index :shares, :user_id

  end

  def self.down
    drop_table :shares
  end
end
