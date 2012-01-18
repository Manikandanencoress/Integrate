require 'spec_helper'

describe Admin::Studios::InvitationsController do
  it_behaves_like "an authorization-required studio admin controller"

  let(:studio_admin) { Factory(:studio_admin) }
  let(:studio) { studio_admin.studio }

  describe "when logged in as a studio admin" do
    let(:studio_invitation) { Factory(:invitation, :studio => studio) }
    let(:redeemed_invitation) { Factory(:invitation, :studio => studio, :redeemer => Factory(:admin)) }
    let(:admin_invitation) { Factory(:invitation) }

    before do
      sign_in(studio_admin)
    end

    describe "GET #index" do
      before do
        get :index, :studio_id => studio.id
      end

      it "exposes the studios unredeemed invites" do
        response.should be_success
        assigns(:invitations).should include(studio_invitation)
        assigns(:invitations).should_not include(admin_invitation)
        assigns(:invitations).should_not include(redeemed_invitation)
      end
    end

    describe "POST #create" do
      before do
        post :create, :invitation => {:email => "ronald@rectangles.org"}, :studio_id => studio.id
      end

      it "should create a user when valid params" do
        Invitation.last.email.should == "ronald@rectangles.org"
        Invitation.last.studio.should == studio

        response.should redirect_to admin_studio_invitations_path(studio)
      end
    end
  end
end