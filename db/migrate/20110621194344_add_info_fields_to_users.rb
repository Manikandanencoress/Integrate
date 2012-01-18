class AddInfoFieldsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :gender
      t.string :city
      t.string :state
      t.string :country
      t.date :birthday
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :gender
      t.remove :city
      t.remove :state
      t.remove :country
      t.remove :birthday
    end
  end
end
