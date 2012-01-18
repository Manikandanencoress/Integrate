class AddToStudioPaypalCredents < ActiveRecord::Migration

  def self.up
    add_column :studios, :paypal_api_user, :string
    add_column :studios, :paypal_api_password, :string
    add_column :studios, :paypal_api_signature, :string
  end

  def self.down
    remove_column :studios, :paypal_api_user
    remove_column :studios, :paypal_api_password
    remove_column :studios, :paypal_api_signature
  end

end
