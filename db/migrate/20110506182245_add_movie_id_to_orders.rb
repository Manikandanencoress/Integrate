class AddMovieIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :movie_id, :integer
  end

  def self.down
    remove_column :orders, :movie_id
  end
end
