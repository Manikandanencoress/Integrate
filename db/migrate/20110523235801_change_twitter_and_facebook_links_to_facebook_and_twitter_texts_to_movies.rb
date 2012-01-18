class ChangeTwitterAndFacebookLinksToFacebookAndTwitterTextsToMovies < ActiveRecord::Migration
  def self.up
    remove_column :movies, :feed_dialog_desc
    remove_column :movies, :share_twitter_link
    remove_column :movies, :share_fb_link
    add_column :movies, :facebook_share_text, :text
    add_column :movies, :twitter_share_text, :text
  end

  def self.down
    add_column :movies, :feed_dialog_desc, :string
    add_column :movies, :share_twitter_link, :string
    add_column :movies, :share_fb_link, :string
    remove_column :movies, :facebook_share_text
    remove_column :movies, :twitter_share_text
  end
end
