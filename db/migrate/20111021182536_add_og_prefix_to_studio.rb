class AddOgPrefixToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :og_prefix, :string
  end

  def self.down
    remove_column :studios, :og_prefix
  end
end
