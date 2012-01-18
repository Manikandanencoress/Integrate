class CreateStreams < ActiveRecord::Migration
  def self.up
    create_table :streams do |t|
      t.integer :movie_id
      t.string :url
      t.integer :bitrate
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :streams
  end
end
