require 'spec_helper'

describe GroupDiscount do

  describe "#validate_discount_key" do
    let(:movie) { Factory :movie }
    let(:group_discount) { Factory :group_discount }

    context "when the offer has expired" do
      before do
        group_discount.created_at = 8.days.ago
      end

      it "should return expired to be true" do
        group_discount.validate_discount_key[1].should == true
      end

      it "should return valid to be false" do
        group_discount.validate_discount_key[0].should == false
      end

      it "should return viewing_party_complete to be false" do
        group_discount.validate_discount_key[2].should == false
      end
    end

    context "when the viewing party is complete" do
      before do
        10.times {RedeemDiscount.create(:group_discount_id => group_discount.id)}
      end
      it "should return viewing_party_complete to be true" do
        group_discount.validate_discount_key[2].should == true
      end

      it "should return valid to be false" do
        group_discount.validate_discount_key[0].should == false
      end

      it "should return expired to be false" do
        group_discount.validate_discount_key[1].should == false
      end

    end

    context "when the offers has not expired and viewing party is not complete" do
      before do
       5.times {RedeemDiscount.create(:group_discount_id => group_discount.id)}
      end
      it "should return valid to be true" do
        group_discount.validate_discount_key[0].should == true
      end

      it "should return expired to be false" do
        group_discount.validate_discount_key[1].should == false
      end

      it "should return viewing_party_complete to be false" do
        group_discount.validate_discount_key[2].should == false
      end
    end


  end

end
