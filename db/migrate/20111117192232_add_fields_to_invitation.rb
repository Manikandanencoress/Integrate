class AddFieldsToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :configuration_only, :boolean
    add_column :invitations, :reporting_only, :boolean
  end

  def self.down
    remove_column :invitations, :configuration_only
    remove_column :invitations, :reporting_only
  end
end
