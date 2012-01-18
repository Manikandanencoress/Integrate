require 'spec_helper'

describe Invitation do
  let(:invitation) {Factory.build(:invitation)}
  describe "before_create" do
    it "should create a token" do
      invitation.token.should_not be_present
      invitation.save
      invitation.token.length.should == 32
    end
  end

  describe "after_create" do
    it "should send an email" do
      invitation.email = 'rainbows@fantasy.com'
      ->{invitation.save!}.should change{InvitationMailer.deliveries.size}.by(1)
      InvitationMailer.deliveries.last.to.should include('rainbows@fantasy.com')
    end
  end

  describe "before_destroy" do
    it "doesn't allow you to delete a redeemed invitation" do
      invitation = Factory(:invitation, :redeemer_id => 5)
      ->{invitation.destroy}.should raise_error("can't delete an invitation that's already been redeemed")
      invitation.redeemer_id = nil
      ->{invitation.destroy}.should_not raise_error
    end
  end

  describe "validations" do
    let(:valid_attributes) { Factory.build(:invitation).attributes }
    describe "token" do
      it "should validate uniqueness" do
        token = "a"*20
        valid_invite = Factory(:invitation)
        valid_invite.token = token
        valid_invite.save
        valid_invite.should be_valid
        invalid_invite = Factory(:invitation)
        invalid_invite.token = token
        invalid_invite.should have(1).error_on(:token)
      end

      it "should validate presence" do
        invitation = Invitation.create(valid_attributes)
        invitation.token = nil
        invitation.should_not be_valid
      end
    end
  end
end
