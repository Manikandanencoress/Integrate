class AddTaxCollectedToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :tax_collected, :string
  end

  def self.down
    remove_column :orders, :tax_collected
  end
end
