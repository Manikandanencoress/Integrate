class AddFieldsToAdmin < ActiveRecord::Migration
  def self.up
    add_column :admins, :configuration_only, :boolean
    add_column :admins, :reporting_only, :boolean
  end

  def self.down
    remove_column :admins, :configuration_only
    remove_column :admins, :reporting_only
  end
end
