class Comment < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user

  def as_json(options = {})
    attributes.merge(
        {
            :comment_id => self.id,
            :user_name => self.user.name_downcase,
            :facebook_user_id => self.user.facebook_user_id
        }
    )
  end

end
