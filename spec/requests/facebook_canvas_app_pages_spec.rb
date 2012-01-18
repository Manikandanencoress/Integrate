require 'spec_helper'

describe "Facebook Canvas App pages" do
  let(:movie) {Factory :movie}
  let(:user) {Factory(:user)}
  let(:signed_request) {FacebookAuthenticationFaker.authed_facebook_signed_request('user_id' => user.facebook_user_id)}

  it "changes POSTs to GETs for movie index page" do
    lambda { get studio_movies_path(movie.studio, :signed_request => signed_request) }.should_not raise_error
    post studio_movies_path(movie.studio, :signed_request => signed_request)
    request.env["REQUEST_METHOD"].should == "GET"
  end

  it "changes POSTs to GETs for movie show page" do
    lambda { get studio_movie_path(movie.studio, movie, :signed_request => signed_request) }.should_not raise_error
    post studio_movie_path(movie.studio, movie, :signed_request => signed_request)
    request.env["REQUEST_METHOD"].should == "GET"
  end

  it "changes POSTs to GETs for order show page" do
    order = movie.orders.create
    order.settle!
    lambda { get studio_movie_order_path(movie.studio, movie, order, :signed_request => signed_request) }.should_not raise_error
    post studio_movie_order_path(movie.studio, movie, order, :signed_request => signed_request)
    request.env["REQUEST_METHOD"].should == "GET"
  end
end