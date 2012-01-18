class CreateFacebookUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :facebook_user_id

      t.timestamps
    end

    add_column :orders, :user_id, :integer
    add_column :page_visits, :user_id, :integer
    remove_column :orders, :facebook_user_id
    remove_column :page_visits, :facebook_user_id

    execute "truncate orders;"
    execute "truncate page_visits;"
  end

  def self.down
    drop_table :users
    remove_column :orders, :user_id
    remove_column :page_visits, :user_id

    add_column :orders, :facebook_user_id, :string
    add_column :page_visits, :facebook_user_id, :string
  end
end
