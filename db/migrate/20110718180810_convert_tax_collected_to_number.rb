class ConvertTaxCollectedToNumber < ActiveRecord::Migration
  class Order < ActiveRecord::Base
  end

  def self.up
    add_column :orders, :tax_collected_float, :float
    convert_all_orders_to_float

    remove_column :orders, :tax_collected
    rename_column :orders, :tax_collected_float, :tax_collected
  end

  def self.down
    add_column :orders, :tax_collected_string, :string
    convert_all_orders_to_string
    remove_column :orders, :tax_collected
    rename_column :orders, :tax_collected_string, :tax_collected
  end

  def self.convert_all_orders_to_float
    Order.all.each do |order|
      order.tax_collected_float = order.tax_collected.to_f
      order.save!
    end
  end

  def self.convert_all_orders_to_string
    Order.all.each do |order|
      order.tax_collected_string = order.tax_collected.to_s
      order.save!
    end
  end

end
