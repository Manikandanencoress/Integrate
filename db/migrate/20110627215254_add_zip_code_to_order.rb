class AddZipCodeToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :zip_code, :integer
  end

  def self.down
    remove_column :orders, :zip_code
  end
end
