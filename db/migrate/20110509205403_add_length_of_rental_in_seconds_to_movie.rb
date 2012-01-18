class AddLengthOfRentalInSecondsToMovie < ActiveRecord::Migration
  def self.up
    add_column :movies, :length_of_rental_in_seconds, :integer
  end

  def self.down
    remove_column :movies, :length_of_rental_in_seconds
  end
end
