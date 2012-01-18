require 'spec_helper'

describe Admin::Studios::Reports::MoviesController do

  describe "#show" do
    let(:studio) { Factory(:studio) }

    describe "rendering" do
      before do
        sign_in Factory(:admin)
      end
      it "should have the studio" do
        get :show, :studio_id => studio.id
        assigns(:studio).should == studio
      end

      it "shouled have a reports instance variable with the studio's movies' reports" do
        movie1 = Factory(:movie, :studio => studio)
        movie2 = Factory(:movie, :studio => studio)
        report1 = movie1.report
        report2 = movie2.report

        get :show, :studio_id => studio.id

        # OMFG !ASS!IGNS IS AN ARRAY OF HASH WITH INDIFFERENT ACCESSES AND IT JUST DOESNT COMPARE PROPERLY
        assigns(:reports).map{|report| report.keys.map(&:to_sym)}.should =~ [report1.keys, report2.keys]
        assigns(:reports).map(&:values).should =~ [report1.values, report2.values]
      end
    end

    describe "authorization" do
      let(:request_to_make) { lambda { get :show, :studio_id => studio.id } }
      it_behaves_like "an admin authenticated action"
    end
  end

end
