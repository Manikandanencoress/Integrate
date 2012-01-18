class AddStudioIdToSeries < ActiveRecord::Migration
  def self.up
    add_column :series, :studio_id, :integer
  end

  def self.down
    remove_column :series, :studio_id
  end
end
