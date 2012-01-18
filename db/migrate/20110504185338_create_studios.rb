class CreateStudios < ActiveRecord::Migration
  def self.up
    create_table :studios do |t|
      t.string :facebook_canvas_page

      t.timestamps
    end
  end

  def self.down
    drop_table :studios
  end
end
