require 'spec_helper'

describe InvitationHelper do
  describe "#reedem_invitation_url" do
    it "generate a url with our token OR ELSE" do
      invitation = Factory(:invitation)
      invitation.stub!(:token).and_return("unicorns")
      invitation_url = helper.redeem_invitation_url(invitation)
      invitation_url.should == new_admin_registration_url(:token => "unicorns", :protocol => "https://")
    end
  end
end