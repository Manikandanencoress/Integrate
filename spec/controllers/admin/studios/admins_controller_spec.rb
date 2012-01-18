require 'spec_helper'

describe Admin::Studios::AdminsController do
  describe "GET index" do
    let(:studio_admin) { Factory :studio_admin }
    let(:studio) { studio_admin.studio }
    let(:other_studios_admin) { Factory :studio_admin }
    before do
      sign_in Factory :admin
      get :index, :studio_id => studio.id
    end

    it "displays all the admins for a studio" do
      assigns(:admins).should include(studio_admin)
    end
    it "doesn't display other studio's admins" do
      assigns(:admins).should_not include(other_studios_admin)
    end
  end
end