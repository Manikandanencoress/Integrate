# I know this is a bizarrely complex migration.
# Apparently Postgres on Heroku was having trouble with long ass column
# names and failing silently.

class ShortenMovieFieldNames < ActiveRecord::Migration
  def self.change_or_create_column_name(table, old_column, new_column, type)
    if column_exists? table, old_column, type
      rename_column table, old_column, new_column
    else
      add_column table, new_column, type
    end
  end

  def self.add_column_if_missing(table, name, type)
    unless column_exists? table, name, type
      add_column table, name, type
    end
  end

  def self.up
    change_or_create_column_name :movies, :background_purchase_image_url, :purchase_bg_url, :string
    change_or_create_column_name :movies, :background_watch_image_url, :watch_bg_url, :string
    add_column_if_missing :movies, :share_fb_link, :string
    add_column_if_missing :movies, :share_twitter_link, :string
    add_column_if_missing :movies, :font_color_help, :string
  end

  def self.down
    change_or_create_column_name :movies, :purchase_bg_url, :background_purchase_image_url, :string
    change_or_create_column_name :movies, :watch_bg_url, :background_watch_image_url, :string
  end
end
