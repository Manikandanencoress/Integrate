class AddSeriesIdToMovie < ActiveRecord::Migration

  def self.up
    add_column :movies, :series_id, :integer, :limit => 6
    add_index :movies, :series_id
  end

  def self.down
    remove_column :movies, :series_id
    remove_index :movies, :series_id
  end

end
