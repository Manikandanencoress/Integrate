class AddCommentStreamEnabledToStudios < ActiveRecord::Migration
  def self.up
    add_column :studios, :comment_stream_enabled, :boolean
  end

  def self.down
    remove_column :studios, :comment_stream_enabled
  end
end
