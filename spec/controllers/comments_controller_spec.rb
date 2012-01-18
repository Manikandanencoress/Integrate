require 'spec_helper'

describe CommentsController do
  describe "POST #create" do
    let(:movie) {Factory(:movie)}
    let(:user) {Factory(:user)}

    it "should create a comment for the movie" do

      comment_params = {
          :text => 'FooBar',
          :commented_at => 123,
      }

      controller.stub(:load_facebook_user).and_return(user)

      post :create, :movie_id => movie.id,
                    :signed_request => 'blahblahblah',
                    :comment => comment_params

      comment = Comment.last
      comment.user.should == user
      comment.commented_at.should == 123
      comment.text.should == 'FooBar'

      comment_json = JSON.parse(response.body)
      comment_json['user_name'].should == user.name_downcase
    end
  end
end
