class Stream < ActiveRecord::Base
 validates_presence_of :bitrate,
                        :url,
                        :width,
                        :height,
                        :movie_id
  belongs_to :movie
end
