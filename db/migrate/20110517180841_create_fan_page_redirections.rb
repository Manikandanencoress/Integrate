class CreateFanPageRedirections < ActiveRecord::Migration
  def self.up
    create_table :fan_page_redirections do |t|
      t.string :facebook_page_id
      t.integer :movie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fan_page_redirections
  end
end
