class AddDiscountRedirectLink < ActiveRecord::Migration
  def self.up
    add_column :movies, :discount_redirect_link, :string
  end

  def self.down
    remove_column :movies, :discount_redirect_link
  end
end
