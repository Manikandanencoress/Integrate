class CreatePageVisits < ActiveRecord::Migration
  def self.up
    create_table :page_visits do |t|
      t.references :movie
      t.string :facebook_user_id
      t.string :page

      t.timestamps
    end
  end

  def self.down
    drop_table :page_visits
  end
end
