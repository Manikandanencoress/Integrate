require 'spec_helper'

describe Admin::Studios::MovieMetricsReportsController do

  describe "GET 'index'" do
    let(:movie) { Factory :movie }
    let(:studio) { movie.studio }
    let(:studio_admin) { Factory(:studio_admin) }
    describe "rendering" do
      before do
        sign_in Factory(:studio_admin)
      end
      
      it "should have the studio" do
        get :index, :studio_id => studio.id
        assigns(:studio).should == studio
      end
      
      it "should have the movie metrics report with the studio's movie's report" do
        movie1 = Factory(:movie, :studio => studio)
        movie2 = Factory(:movie, :studio => studio)
        movie3 = Factory(:movie)
        get :index, :studio_id => studio.id
        
        assigns(:movies).should include(movie1)
        assigns(:movies).should include(movie2)
        assigns(:movies).should_not include(movie3)        
      end
      
    end
  end

end
