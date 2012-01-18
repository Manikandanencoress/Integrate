class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :text
      t.integer :commented_at
      t.belongs_to :movie
      t.belongs_to :user

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
