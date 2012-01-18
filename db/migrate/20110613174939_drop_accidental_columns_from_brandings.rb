class DropAccidentalColumnsFromBrandings < ActiveRecord::Migration
  def self.up
    remove_column :brandings, :string
    remove_column :brandings, :datetime
    remove_column :brandings, :integer
  end

  def self.down
  end
end
