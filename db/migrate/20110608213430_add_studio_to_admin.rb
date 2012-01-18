class AddStudioToAdmin < ActiveRecord::Migration
  def self.up
    add_column :admins, :studio_id, :integer
  end

  def self.down
    remove_column :admins, :studio_id
  end
end
