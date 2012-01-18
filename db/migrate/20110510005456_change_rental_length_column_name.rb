class ChangeRentalLengthColumnName < ActiveRecord::Migration
  def self.up
    rename_column :movies, :length_of_rental_in_seconds, :rental_length
  end

  def self.down
    rename_column :movies, :rental_length, :length_of_rental_in_seconds 
  end
end
