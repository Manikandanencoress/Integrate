class AddPayDialogFieldsToMovies < ActiveRecord::Migration
  def self.up
    add_column :movies, :description, :string
    add_column :movies, :pay_dialog_image, :string
    add_column :movies, :pay_dialog_title, :string
  end

  def self.down
    remove_column :movies, :pay_dialog_title
    remove_column :movies, :pay_dialog_image
    remove_column :movies, :description
  end
end
