class AddActionLink < ActiveRecord::Migration
  def self.up
    add_column :movies, :action_link_name, :string
    add_column :movies, :action_link_url, :string
  end

  def self.down
    remove_column :movies, :action_link_name
    remove_column :movies, :action_link_url
  end
end
