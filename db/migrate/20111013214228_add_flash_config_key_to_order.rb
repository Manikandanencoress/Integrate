class AddFlashConfigKeyToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :flash_config_key, :string
  end

  def self.down
    remove_column :orders, :flash_config_key
  end
end
