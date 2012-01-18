class AddGeoRestrictionsToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :white_listed_country_codes, :string
    add_column :studios, :black_listed_country_codes, :string
  end

  def self.down
    remove_column :studios, :white_listed_country_codes
    remove_column :studios, :black_listed_country_codes
  end
end
