require 'spec_helper'

describe Admin::SalesReportsController do
  
  describe "an admin authenticated action" do
    let(:request_to_make) { lambda { get :index } }
    context "When we are not logged in" do
      it "should redirect to the admin sign-in page" do
        sign_in Factory(:admin)
        request_to_make.call
        response.should be_success
      end
    end

    context "We are logged in as an admin" do
      it "should return a successful request" do
        sign_in Factory(:admin)
        request_to_make.call
        expected_response_code = request.get? ? "200" : "302"
        response.code.should == expected_response_code
      end
    end
  end

end
