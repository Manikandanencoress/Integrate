require "spec_helper"

describe Admin::InvitationsController do
#  it_behaves_like "an authorization-required studio admin controller"
  it "has some sort of authorization around it"

  describe "a GET to show" do
    let(:request_to_make) {lambda{get :show, :id => 9001}}

    it "should be an authenticated action" do
      request_to_make.call
      response.should redirect_to(new_admin_session_path)
    end

    it "should redirect with the flash to index" do
      sign_in Factory(:admin)
      request_to_make.call
      response.should redirect_to(admin_invitations_path)
    end
  end

  describe "a GET to index" do
    before do
      @redeemed = Factory(:invitation)
      Factory(:admin, :invitation => @redeemed )
      @unredeemed = Factory(:invitation)
    end

    it "should only show unredeemed invitations" do
      sign_in Factory(:admin)
      get :index
      assigns(:invitations).should include(@unredeemed)
      assigns(:invitations).should_not include(@redeemed)
    end
  end
end