require 'spec_helper'
describe "FacebookPay Requests" do
  describe "when given a POST with a signed request" do
    let(:studio) {Factory(:studio)}
    it "should remain a post and not get fixed to a GET" do
      signed_request = "123.456"
      post "/api/facebook_pay/studios/#{studio.id}/callback", :signed_request => signed_request
      request.env["REQUEST_METHOD"].should == "POST"
    end
  end
end