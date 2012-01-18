class ChangeSupportEmailToHelpTextInStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :help_text, :text
    remove_column :studios, :support_email
  end

  def self.down
    remove_column :studios, :help_text
    add_column :studios, :support_email, :string
  end
end
