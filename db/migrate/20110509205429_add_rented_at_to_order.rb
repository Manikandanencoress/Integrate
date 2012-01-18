class AddRentedAtToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :rented_at, :datetime
  end

  def self.down
    remove_column :orders, :rented_at
  end
end
