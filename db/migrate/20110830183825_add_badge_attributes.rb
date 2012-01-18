class AddBadgeAttributes < ActiveRecord::Migration
  def self.up
    add_column :movies, :badge_number, :integer
    add_column :movies, :badge_text, :string
  end

  def self.down
    remove_column :movies, :badge_number
    remove_column :movies, :badge_text
  end
end
