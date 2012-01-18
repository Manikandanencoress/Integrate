require 'spec_helper'

describe MovieMetricsReport do
  
  describe "associations" do
    it "should belong_to :movie" do
       movie = Factory(:movie)
       movie_metrics_report = Factory.build(:movie_metrics_report)
       movie_metrics_report.movie = movie
       movie_metrics_report.save
       movie_metrics_report.reload.movie.should == movie 
    end
  end
  
end
