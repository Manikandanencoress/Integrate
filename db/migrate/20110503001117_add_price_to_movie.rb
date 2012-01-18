class AddPriceToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :price, :integer
  end

  def self.down
    remove_column :movies, :price
  end
end
