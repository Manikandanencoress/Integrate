class AddPaypalEnabledToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :paypal_enabled, :boolean
  end

  def self.down
    remove_column :studios, :paypal_enabled
  end
end
