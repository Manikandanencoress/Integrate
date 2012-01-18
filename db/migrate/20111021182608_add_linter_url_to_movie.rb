class AddLinterUrlToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :linter_url, :string
  end

  def self.down
    remove_column :movies, :linter_url
  end
end
