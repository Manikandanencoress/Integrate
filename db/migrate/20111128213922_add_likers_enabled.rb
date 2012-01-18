class AddLikersEnabled < ActiveRecord::Migration

  def self.up
    add_column :movies, :fb_likers_enabled, :boolean

    Movie.all.each do |i|
      i.update_attributes :wysiwyg_fan_page_likers_y => i.like_box_top,
                          :wysiwyg_fan_page_likers_x => i.like_box_left if i.like_box_top
    end

  end

  def self.down
    remove_column :movies, :fb_likers_enabled
  end

end