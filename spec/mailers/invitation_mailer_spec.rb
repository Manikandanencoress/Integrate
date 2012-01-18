require 'spec_helper'

describe InvitationMailer do
  before do
    InvitationMailer.deliveries = []
  end
  
  describe "#invitaion_email" do
    it "should send an email, with the invitations token in it" do
      invitation = Factory(:invitation)
      invitation.stub!(:token).and_return("unicorns")
      mail = InvitationMailer.invite(invitation)
      mail.body.should include(new_admin_registration_url(:token => "unicorns", :protocol => "https://"))
    end
  end

end