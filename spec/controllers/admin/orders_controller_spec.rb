require 'spec_helper'

describe Admin::OrdersController do

  before do
    sign_in Factory(:admin)
  end

  describe "csv file" do

    it "returns a csv file when the path includes a csv mime type" do
      studio = Factory :studio
      movie1 = Factory :movie, :studio_id => studio.id
      10.times {Factory :order, :movie_id => movie1.id }
      get :index, :studio_id => studio.id, :movie_id => movie1.id, :format => 'csv'
      response.status.should == 200
      csv_object = CSV.parse(response.body)
      csv_object.count.should == 11
    end
  end
end