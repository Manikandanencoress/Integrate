require 'spec_helper'

describe Admin::AdminReportsController do

  describe "GET 'index'" do    
    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end      
      it "should list all available studio" do
        get :index
        assigns(:studios).should_not be_nil
      end      
    end
  end

  describe "GET 'update_movie_list'" do
    let(:studio) { Factory :studio }
    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end      
      it "should list all available movie's for the particular studio" do
        get :update_movie_list, :id => studio.id
        assigns(:movies).should_not be_nil
      end      
    end
  end
  
  describe "GET 'update_user_list'" do
    let(:movie) { Factory(:movie) }
    let(:studio) { movie.studio }
    let(:user) {Factory(:user)}

    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end      
      it "should list ordered user list for this studio & movie" do
        get :update_user_list, :movieid => movie.id
        assigns(:orders).should_not be_nil
      end
      it "should list Purchased Movies for this user" do
        get :update_user_list, :userid => user.id
        assigns(:purchasedmovies).should_not be_nil
      end
    end
  end
  
end
