require 'spec_helper'
describe "Admin Pages" do
  describe "sign in pages" do

    it "don't do geo restriction" do
      get 'https://example.com/admin/sign_in'
      response.should be_success
    end
  end
end