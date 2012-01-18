require 'spec_helper'

describe PriceCalculator do
  context "#prices_for" do

    it "returns nil without a zipcode" do
      PriceCalculator.prices_for(1, nil).should be_nil
    end

    context "given a tax rate of 0" do
      it "returns the prices" do
        TaxRateService.should_receive(:rate_for).with('abc').and_return(0)
        price_hash = PriceCalculator.prices_for(30, 'abc')
        price_hash.should == {:price => 30, :tax => 0, :total => 30}
      end
    end

    context "given the tax + price is a whole number" do
      it "returns the prices" do
        TaxRateService.should_receive(:rate_for).with('abc').and_return(0.1)
        price_hash = PriceCalculator.prices_for(30, 'abc')
        price_hash.should == {:price => 30, :tax => 3, :total => 33}
      end
    end

    context "given the tax + price is not a whole number" do
      before do
        TaxRateService.should_receive(:rate_for).with('abc').and_return(0.0975)
        @price_hash = PriceCalculator.prices_for(30, 'abc')
      end

      it "rounds up the total" do
        @price_hash[:total].should == 33 # rounded up from 32.925
      end

      it "recalculates the tax and price to go with the new total" do
        @price_hash[:tax].should == 2.93
        @price_hash[:price].should == 30.07
      end

      it "works with other numbers, too" do
        TaxRateService.should_receive(:rate_for).with('abc').and_return(0.0870)
        @price_hash = PriceCalculator.prices_for(30, 'abc')
        @price_hash.should == { :price => 30.36, :tax => 2.64, :total => 33 }
      end
    end
  end
end
