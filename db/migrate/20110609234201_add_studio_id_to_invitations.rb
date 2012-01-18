class AddStudioIdToInvitations < ActiveRecord::Migration
  def self.up
    add_column :invitations, :studio_id, :integer
  end

  def self.down
    remove_column :invitations, :studio_id
  end
end
