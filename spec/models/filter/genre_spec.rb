require 'spec_helper'

describe Filter::Genre do
  it "should properly inherit from informal" do
    Filter.model_name.human.should == "Filter"
  end

  describe "#initlialize" do
    context "when the genre exists" do
      it "should set the genre" do
        Factory(:movie, :genre_list => 'parties')
        @filter = Filter::Genre.new(:genre => "parties")
        @filter.genre.should == "parties"
      end
    end

    context "when the genre doesn't exist" do
      it "the genre should be nil" do
        @filter = Filter::Genre.new(:genre => "uber leet rectangle parties")
        @filter.genre.should == nil
      end
    end
  end

  describe "#filter_movie_scope" do
    context "with a genre" do
      it "filters the scope it is passed" do
        teen_dramedy = Factory(:movie, :genre_list => 'teen dramedy')
        action_film = Factory(:movie, :genre_list => 'action film')

        @filter = Filter::Genre.new(:genre => "teen dramedy")
        movies = @filter.filter_movie_scope(Movie.scoped)
        movies.should include(teen_dramedy)
        movies.should_not include(action_film)
      end
    end

    context "without a genre" do
      it "returns the original scope" do
        @filter = Filter::Genre.new({})
        @filter.filter_movie_scope(Movie.scoped).should == Movie.scoped
      end
    end
  end
end