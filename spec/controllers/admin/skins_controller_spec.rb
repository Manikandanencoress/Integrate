require 'spec_helper'

describe Admin::SkinsController do
  describe "authorization" do
    let(:movie) {Factory(:movie)}
    before do
      @auth_params = {:movie_id => movie.id, :studio_id => movie.studio.id }
    end
    it_behaves_like "an authorization-required studio admin controller"
  end
  
  describe "GET #show" do
    let(:movie) { Factory(:movie) }
    let(:request_to_make) do
      lambda { get :show, :studio_id => movie.studio.id, :movie_id => movie.id }
    end

    it_behaves_like "an admin authenticated action"

    it "should be on the skin page for the passed in movie" do
      sign_in Factory(:admin)
      request_to_make.call
      assigns(:studio).should == movie.studio
      assigns(:movie).should == movie
      assigns(:skin).should == movie.skin
    end
  end

  describe "GET #edit" do
    let(:movie) { Factory(:movie) }

    let(:request_to_make) do
      lambda { get :edit, :studio_id => movie.studio.id, :movie_id => movie.id }
    end

    it_behaves_like "an admin authenticated action"

    it "should be on the skin page for the passed in movie" do
      sign_in Factory(:admin)
      request_to_make.call
      assigns(:skin).should == assigns(:movie).skin
    end
  end

  describe "PUT #update" do
    let(:movie) { Factory(:movie) }
    let(:request_to_make) do
      lambda {
        old_params = movie.skin.attributes
        skin_params = old_params.merge({:purchase_background => File.new('./spec/support/images/image.jpg')})
        put :update, :studio_id => movie.studio.id, :movie_id => movie.id, :skin => skin_params
      }
    end

    it_behaves_like "an admin authenticated action"

    it "should be on the skin page for the passed in movie" do
      movie.skin.purchase_background = nil
      movie.save
      sign_in Factory(:admin)
      request_to_make.call
      assigns(:skin).purchase_background.should be_present
    end
  end
end
