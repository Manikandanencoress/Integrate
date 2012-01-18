require 'spec_helper'

describe Admin::Studios::SalesReportsController do

  let(:studio_admin) { Factory(:studio_admin) }
  let(:studio) { studio_admin.studio }

  describe "when logged in as a studio admin" do

    before do
      sign_in(studio_admin)
    end
    
    it "authenticates the admin" do
      controller.current_admin.should == studio_admin
    end
  
    it "authorized admin controller" do
      response.should be_success
    end
    
    describe "GET #index" do
      before do
        get :index, :studio_id => studio.id
      end
    end

  end

end
