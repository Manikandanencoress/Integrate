class AddIndexes < ActiveRecord::Migration
  def self.up

  end

  def self.down
    add_column :clips, :movie_id, :integer
    add_index :likes, :movie_id
    add_index :quotes, :movie_id
    add_index :clips, :movie_id


  end
end
