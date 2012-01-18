require 'spec_helper'

describe Admin::InfoStudiosController do

  describe "GET 'index'" do
    let(:request_to_make) { lambda { get :index } }
    
    describe "role-based authorizations" do
      let(:admin_studio) { Factory :studio }
      let(:studio_admin) { Factory :admin, :studio => admin_studio }
      context "as a studio admin" do
        it "should redirect to admin's studio page" do
          sign_in studio_admin
          request_to_make.call
          response.code.should == "200"
        end
      end
    end

  end

end
