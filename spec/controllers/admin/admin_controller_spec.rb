require 'spec_helper'

describe AdminController do
  controller(AdminController) do
    def index
      render :text => "Anybody can see this"
    end
  end

  it "should allow users with non us ip addresses" do
    sign_in Factory(:admin)
    @request.env['REMOTE_ADDR'] = "1.0.0.1" # Australian!
    get :index
    response.should be_success
    response.body.should == "Anybody can see this"
  end

end