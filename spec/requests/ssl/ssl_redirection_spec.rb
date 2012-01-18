require 'spec_helper'
describe "SSL requirements" do
  let(:studio){ Factory :studio}
  describe "non-admin namespaced routes" do
    it "leaves HTTP requests alone" do
      get "http://example.com/studios/#{studio.id}/movies"
      response.code.should == '200'
    end
    it "leaves HTTPS requests alone" do
      get "https://example.com/studios/#{studio.id}/movies"
      response.code.should == '200'
    end
  end
  describe "admin namespaced routes" do
    it "leaves HTTPS requests alone" do
      get "https://example.com/admin/sign_in"
      response.code.should == "200"
    end
    it "redirects HTTP to HTTPS" do
      get "http://example.com/admin/sign_in"
      response.code.should == "301"
    end
  end
end