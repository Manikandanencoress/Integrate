require 'spec_helper'

describe Admin do
  describe "roles" do
    let(:admin) { Factory :admin }
    context "when they belong to a studio" do
      before do
        admin.studio = Factory(:studio)
      end
      it "#studio_admin? returns true" do
        admin.should be_studio_admin
      end
      it "#milyoni_admin? returns false" do
        admin.should_not be_milyoni_admin
      end
    end

    context "when they don't belong to a studio" do
      it "#studio_admin? returns false" do
        admin.should_not be_studio_admin
      end
      it "#milyoni_admin? returns true" do
        admin.should be_milyoni_admin
      end
    end

    describe "before_create" do
      it "should assign the studio from the invitation" do
        studio = Factory(:studio)
        admin = Factory.build(:admin)
        admin.invitation = Factory(:invitation, :studio => studio)
        admin.save!
        admin.studio.should == admin.invitation.studio
      end

      it "should assign the studio when given an explicit one" do
        studio = Factory(:studio)
        admin = Factory(:admin, :studio => studio)
        admin.studio.should == studio
      end
    end
  end
end
