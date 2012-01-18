require 'spec_helper'

describe Admin::UserDetailReportsController do

  describe "GET 'index'" do
    let(:order) {Factory(:order)}
    let(:user) {order.user}
    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end      
      it "should list all available studio" do
        get :index
        assigns(:users).should_not include(user)
        response.should be_success
      end      
    end
  end

  describe "GET 'update_user_detail'" do
    let(:user) {Factory(:user)}
    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end      
      it "should list Purchased Movies for this user" do
        get :update_user_detail, :userid => user.id
        assigns(:user).should_not be_nil
      end
    end
  end
  
end
