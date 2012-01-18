require 'spec_helper'

describe SupportsController do

  before do 
     sign_in Factory(:admin)
  end
  
  describe "GET 'documentation'" do
    it "should be successful" do
      get 'documentation'
      response.should be_success
    
    end
  end

  describe "GET 'faqs'" do
    it "should be successful" do
     get 'faqs'
      response.should be_success
    end
  end

  describe "GET 'tutorial'" do
    it "should be successful" do
      get 'tutorial'
      response.should be_success
    end
  end

  describe "GET 'contactus'" do
    it "should be successful" do
      get 'contactus'
      response.should be_success
    end
  end

end
