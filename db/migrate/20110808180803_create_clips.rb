class CreateClips < ActiveRecord::Migration
  def self.up
    create_table :clips do |t|
      t.string :video_id
      t.string :thumbnail_url
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :clips
  end
end
