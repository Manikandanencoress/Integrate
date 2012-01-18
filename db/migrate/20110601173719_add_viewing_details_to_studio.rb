class AddViewingDetailsToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :viewing_details, :text
  end

  def self.down
    remove_column :studios, :viewing_details
  end
end
