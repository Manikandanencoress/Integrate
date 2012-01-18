class ConvertZipCodesToString < ActiveRecord::Migration
  def self.up
    change_column :orders, :zip_code, :string
  end

  def self.down
    change_column :orders, :zip_code, :integer
  end
end
