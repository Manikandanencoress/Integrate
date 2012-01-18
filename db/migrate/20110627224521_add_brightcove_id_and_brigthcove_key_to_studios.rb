class AddBrightcoveIdAndBrigthcoveKeyToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :brightcove_id, :string
    add_column :studios, :brightcove_key, :string
  end

  def self.down
    remove_column :studios, :brightcove_key
    remove_column :studios, :brightcove_id
  end
end
