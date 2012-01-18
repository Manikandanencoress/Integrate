class AddMaxIpsForMovieToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :max_ips_for_movie, :integer
    execute("UPDATE studios SET max_ips_for_movie=3")
  end

  def self.down
    remove_column :studios, :max_ips_for_movie
  end
end