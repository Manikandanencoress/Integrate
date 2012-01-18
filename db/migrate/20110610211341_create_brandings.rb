class CreateBrandings < ActiveRecord::Migration
  def self.up
    create_table :brandings do |t|
      t.text :name
      t.integer :studio_id
      t.string :logo_file_name, :string
      t.string :logo_content_type, :string
      t.integer :logo_file_size, :integer
      t.datetime :logo_updated_at, :datetime

      t.timestamps
    end

  end

  def self.down
    drop_table :brandings
  end
end
