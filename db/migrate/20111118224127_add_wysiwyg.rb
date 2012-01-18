class AddWysiwyg < ActiveRecord::Migration

  def self.up
    add_column :movies, :wysiwyg_watch_now_x, :float
    add_column :movies, :wysiwyg_watch_now_y, :float 

    add_column :movies, :wysiwyg_rental_length_x, :float 
    add_column :movies, :wysiwyg_rental_length_y, :float 

    add_column :movies, :wysiwyg_share_buttons_x, :float 
    add_column :movies, :wysiwyg_share_buttons_y, :float 

    add_column :movies, :wysiwyg_fan_page_likers_x, :float 
    add_column :movies, :wysiwyg_fan_page_likers_y, :float 

    add_column :movies, :wysiwyg_coupon_code_x, :float 
    add_column :movies, :wysiwyg_coupon_code_y, :float 

    add_column :movies, :custom_button_watch_now, :string, :limit => 140
    add_column :movies, :custom_link_coupon_code, :string

  end

  def self.down
    remove_column :movies, :wysiwyg_watch_now_x
    remove_column :movies, :wysiwyg_watch_now_y
    remove_column :movies, :wysiwyg_rental_length_x
    remove_column :movies, :wysiwyg_rental_length_y
    remove_column :movies, :wysiwyg_fan_page_likers_x
    remove_column :movies, :wysiwyg_fan_page_likers_y
    remove_column :movies, :wysiwyg_coupon_code_x
    remove_column :movies, :wysiwyg_coupon_code_y
    remove_column :movies, :wysiwyg_share_buttons_x
    remove_column :movies, :wysiwyg_share_buttons_y
    remove_column :movies, :custom_button_watch_now
    remove_column :movies, :custom_link_coupon_code
  end

end