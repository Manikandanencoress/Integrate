require 'spec_helper'

describe ApplicationHelper do

  describe "#change_to_https" do
    it "should return the url changed with https" do
      url = "http://www.google.com"
      change_to_https(url).should == "https://www.google.com"
    end
  end

  describe "#facebook_friends" do
    it "should return an array of facebook friends" do
      facebook_friends.should == "[]"
    end
  end

  describe "#decimal_ratio_to_percentage" do
    it "returns a percentage with 3 significant decimals for a number" do
      helper.decimal_ratio_to_percentage(0.16).should == "16.000%"
      helper.decimal_ratio_to_percentage(0.16123).should == "16.123%"
    end

    it "returns 0.000% when the ratio is nil" do
      helper.decimal_ratio_to_percentage(nil).should == "0.000%"
    end
  end


end