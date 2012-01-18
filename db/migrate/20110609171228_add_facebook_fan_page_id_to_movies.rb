class AddFacebookFanPageIdToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :facebook_fan_page_id, :string
    # would migrate old data if we had some
    drop_table :fan_page_redirections
  end

  def self.down
    remove_column :movies, :facebook_fan_page_id
    create_table "fan_page_redirections", :force => true do |t|
      t.string   "facebook_page_id"
      t.integer  "movie_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
