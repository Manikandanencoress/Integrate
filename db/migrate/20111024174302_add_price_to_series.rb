class AddPriceToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :price, :integer
    add_column :series, :enable_series_pass, :boolean
  end

  def self.down
    remove_column :series, :price
    remove_column :series, :enable_series_pass
  end
end
