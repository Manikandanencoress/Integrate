require 'spec_helper'

describe Admin::Studios::Reports::TaxController do
  before do
    sign_in Factory :admin
  end

  describe "GET #show" do
    it "should have all the studio's orders" do
      studio = Factory(:studio)
      harry_potter = Factory(:movie, :studio => studio)
      star_trek = Factory(:movie, :studio => studio)
      3.times { harry_potter.orders.create.settle!}
      3.times { star_trek.orders.create}

      get :show, :studio_id => studio.id

      (assigns(:orders) & harry_potter.orders).should == harry_potter.orders
      (assigns(:orders) & star_trek.orders).should == star_trek.orders
    end
  end
end