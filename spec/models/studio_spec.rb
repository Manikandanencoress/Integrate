require 'spec_helper'

describe Studio do
  describe "validations" do

    %w{
       name
       facebook_canvas_page
       help_text
       privacy_policy_url
      }.each do |attr|
      it "should validate presence of #{attr}" do
        s = Studio.new
        s.valid?
        s.should have(1).errors_on(attr.to_sym)
      end
    end

    it "validates numericality of max_ips_for_movie" do
      s = Studio.new :max_ips_for_movie => "abc"
      s.valid?
      s.should have(1).errors_on(:max_ips_for_movie)
    end
  end

  describe "associations" do
    it "should have_many :movies" do
      studio = Factory(:studio)
      movie = Factory.build(:movie, :studio => nil)
      studio.movies << movie
      studio.save!
      studio.reload.movies.should include(movie)
    end
  end

  describe "#before_create" do
    it "should set set the branding" do
      studio = Factory.build(:studio)
      studio.branding.should_not be_present
      studio.save!
      studio.branding.should be_present
    end
  end

  describe "#genres" do
    let(:genred_object) { Factory(:studio) }
    it_should_behave_like "an object that's tagged with genre"
  end

  describe "#genre_list" do
    let(:studio) { Factory.build :studio, :genre_list => "" }
    it "should always return the genres in alphabetical order" do
      studio.genre_list = "Family, Sci-Fi, Comedy"
      studio.save
      studio.genre_list.should == ["Comedy", "Family", "Sci-Fi"]
    end
  end

  describe "#is_warner?" do
    studio = Factory(:studio, :player => "warner bros.")
    studio.is_warner?.should == true
    studio.update_attributes(:player => "FUNamation")
    studio.is_warner?.should == false
  end



end

