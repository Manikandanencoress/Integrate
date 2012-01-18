class CreateHotSpots < ActiveRecord::Migration
  def self.up
    create_table :hot_spots do |t|
      t.integer :movie_id
      t.integer :marked_at

      t.timestamps
    end
  end

  def self.down
    drop_table :hot_spots
  end
end
