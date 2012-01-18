class CreateInvitations < ActiveRecord::Migration

  def self.up

    create_table :invitations do |t|
      t.string :email
      t.string :token
      t.integer :creator_id
      t.integer :redeemer_id

      t.timestamps
    end

  end

  def self.down
    drop_table :invitations
  end
end
