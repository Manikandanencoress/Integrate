class AddFacebookFanPageUrlToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :facebook_fan_page_url, :string
  end

  def self.down
    remove_column :movies, :facebook_fan_page_url
  end
end
