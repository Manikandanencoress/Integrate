class AddFacebookAppSecretToStudios < ActiveRecord::Migration
  FACEBOOK_APP_SECRET = {
      "development" => "afe875fe56eb84fee0b3a5dd7af63034",
      "staging" => "afe875fe56eb84fee0b3a5dd7af63034",
      "production" => "90024bfaf13e441db9135e615920a99b",
      "test" => "idontcare",
      "sandbox" => "66216cb38e0f1c2c8162e20e557bdc27"
  }

  def self.up
    add_column :studios, :facebook_app_secret, :string
    execute("UPDATE studios SET facebook_app_secret='#{FACEBOOK_APP_SECRET[Rails.env]}'")
  end

  def self.down
    remove_column :studios, :facebook_app_secret
  end
end
