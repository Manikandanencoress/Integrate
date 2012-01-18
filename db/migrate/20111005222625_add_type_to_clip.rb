class AddTypeToClip < ActiveRecord::Migration

  def self.up
    add_column :clips, :is_commentary, :boolean
  end

  def self.down
    remove_column :clips, :is_commentary
  end

end
