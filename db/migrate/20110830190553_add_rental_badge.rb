class AddRentalBadge < ActiveRecord::Migration
  def self.up
    add_column :movies, :rental_badge, :boolean
  end

  def self.down
    remove_column :movies, :rental_badge
  end
end
