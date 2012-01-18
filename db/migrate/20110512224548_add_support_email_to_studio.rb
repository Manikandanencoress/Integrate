class AddSupportEmailToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :support_email, :string
  end

  def self.down
    remove_column :studios, :support_email
  end
end
