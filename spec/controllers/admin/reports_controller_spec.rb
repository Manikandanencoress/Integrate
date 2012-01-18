require 'spec_helper'

describe Admin::ReportsController do
  render_views
  let(:movie) { Factory :movie }

  describe "authorization" do
    before do
      @auth_params = {:movie_id => movie.id, :studio_id => movie.studio.id }
    end
    it_behaves_like "an authorization-required studio admin controller"
  end

  describe "GET show" do
    let(:studio) { movie.studio }
    let(:request_to_make) do
      lambda { get :show, :studio_id => studio.id, :movie_id => movie.id }
    end

    it_behaves_like "an admin authenticated action"

    describe "rendering" do
      let(:report) { double("report for movie", :[] => "foo") }
      before do
        Movie.should_receive(:find).with(movie.id).and_return(movie)
        movie.should_receive(:report).and_return(report)
        sign_in Factory(:admin)
        request_to_make.call
      end

      it "renders" do
        response.should be_success
      end

      it "finds it's parent movie" do
        assigns(:movie).should == movie
      end

      it "creates a report object" do
        assigns(:report).should == report
      end
    end

  end
end