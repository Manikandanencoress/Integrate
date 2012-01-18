require 'spec_helper'

describe Coupon do

  describe "#price" do
    it "sets the order price according to the discount percentage" do
      movie = Factory(:movie)
      movie.price = 40
      coupon = Factory(:coupon, :movie => movie)

      coupon.percent = 50
      coupon.save
      coupon.movie.price.should == 40
      coupon.price.should == 20

      coupon.percent = 100
      coupon.save
      coupon.price.should == 0
    end

  end
end
