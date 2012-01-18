class AddCopyrightNoticeToStudio < ActiveRecord::Migration
  def self.up
    add_column :studios, :copyright_notice, :text
  end

  def self.down
    remove_column :studios, :copyright_notice
  end
end
