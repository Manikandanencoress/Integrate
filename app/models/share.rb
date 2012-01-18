class Share < ActiveRecord::Base

  belongs_to :user
  belongs_to :like, :counter_cache => true
  belongs_to :clip, :counter_cache => true
  belongs_to :quote, :counter_cache => true

  scope :popular_clips, where("clip_id IS NOT NULL")

end
