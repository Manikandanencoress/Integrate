class AddPrivacyPolicyUrlToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :privacy_policy_url, :string
  end

  def self.down
    remove_column :studios, :privacy_policy_url
  end
end
