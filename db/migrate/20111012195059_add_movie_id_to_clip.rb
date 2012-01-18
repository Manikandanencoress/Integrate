class AddMovieIdToClip < ActiveRecord::Migration
  def self.up
    add_column :clips, :movie_id, :integer, :limit => 6
    add_index :clips, :movie_id
    add_index :quotes, :movie_id
    add_index :likes, :movie_id
  end

  def self.down
    remove_column :clips, :movie_id
    add_column :clips, :movie_id, :integer, :limit => 6
    add_index :clips, :movie_id
  end


end
