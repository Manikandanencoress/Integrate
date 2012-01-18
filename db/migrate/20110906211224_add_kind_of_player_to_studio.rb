class AddKindOfPlayerToStudio < ActiveRecord::Migration

  def self.up
    add_column :studios, :player, :string, :limit => 40, :default => 'milyoni'
    add_index :studios, :player
  end

  def self.down
    remove_column :studios, :player
  end

end
