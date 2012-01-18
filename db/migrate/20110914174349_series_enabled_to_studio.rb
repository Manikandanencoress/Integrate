class SeriesEnabledToStudio < ActiveRecord::Migration

  def self.up
    add_column :studios, :series_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :studios, :series_enabled
  end

end
