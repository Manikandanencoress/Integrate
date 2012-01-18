require 'spec_helper'

describe User do

  describe "#downcase" do
    it("makes sure the name is down cased") do
      user = Factory(:user, :name => 'Kevin Smith')
      user.name_downcase.should == "kevin smith"
    end
  end

  describe ".validations" do
    describe "#facebook_user_id" do
      it "should be required" do
        Factory.build(:user, :facebook_user_id => nil).should_not be_valid
      end

      it "should be unique" do
        Factory(:user, :facebook_user_id => 'foo')
        Factory.build(:user, :facebook_user_id => 'foo').should_not be_valid
      end
    end
  end

  describe ".find_or_create_from_fb_graph" do
    context "when the user doesn't exist" do
      before do
        @mock_fb_user = double(:fb_graph_user, {:name => 'Jim Bob',
                                                :identifier => "namaste_new_friend",
                                                :location => nil,
                                                :email => "jimjam@super.com",
                                                :birthday => "Tue, 28 Oct 1986",
                                                :gender => "Superhero"})
        @mock_fb_user.stub!(:fetch).and_return(@mock_fb_user)
      end

      let(:mock_facebook) { double(:facebook, :user => @mock_fb_user, :data => {:user => {:country => "us"}}) }

      it "should fetch and set the users attributes from facebook" do
        pre_fetch_user = double(:fb_graph_user_pre_fetch, {:name => nil, :identifier => "namaste_new_friend"})
        mock_facebook.stub!(:user).and_return(pre_fetch_user)
        pre_fetch_user.should_receive(:fetch).and_return(@mock_fb_user)

        user = User.find_or_create_from_fb_graph(mock_facebook)
        user.new_record?.should be_false
        user.name.should == 'Jim Bob'
        user.gender.should == "Superhero"
        user.country.should == "US"
        user.email.should == "jimjam@super.com"
        user.birthday.should == Date.parse("Tue, 28 Oct 1986")
        user.facebook_user_id.should == 'namaste_new_friend'
      end

      describe "with a nil location" do
        it "should set the city and state when the location is present" do
          @mock_fb_user.stub!(:location).and_return(double(:fb_location, :name => "San Luis Obispo, Texas"))
          user = User.find_or_create_from_fb_graph(mock_facebook).reload
          user.city.should == "San Luis Obispo"
          user.state.should == "Texas"
        end

        it "should be happy when we don't have  a location" do
          @mock_fb_user.stub!(:location).and_return(nil)
          expect { User.find_or_create_from_fb_graph(mock_facebook) }.to change { User.count }.by(1)
        end

        it "should be happy when the location's name is nil" do
          @mock_fb_user.stub!(:location).and_return(double(:location, :name => nil))
          mock_facebook.user.location.name.should be_nil
          user = User.find_or_create_from_fb_graph(mock_facebook).reload
          user.city.should be_nil
          user.state.should be_nil
        end
      end
    end

    context "when the user already exists" do
      before do
        @mock_fb_user = double(:fb_graph_user, {:name => 'Milyoni Power User', :identifier => 'power_user_1'})
        @mock_fb_user.stub(:fetch).and_return(@mock_fb_user)
        @facebook_user = Factory(:user, :facebook_user_id => 'power_user_1')
        @mock_facebook = double(:facebook, {:user => @mock_fb_user})
      end

      it "should return the existing user" do
        User.find_or_create_from_fb_graph(@mock_facebook).should == @facebook_user
      end
    end
  end

  describe "#currently_rented_movies" do
    before do
      @user = Factory :user

      @studio1 = Factory :studio
      @studio2 = Factory :studio

      @active_movie1 = Factory :movie, :studio_id => @studio1.id
      @active_movie2 = Factory :movie, :studio_id => @studio2.id

      @active_order1 = Factory :settled_order, :movie => @active_movie1, :user => @user
      @active_order2 = Factory :settled_order, :movie => @active_movie2, :user => @user
      @expired_movie = Factory :movie
      @expired_order = Factory :settled_order, :movie => @expired_movie, :rented_at => 100.days.ago, :user => @user
      @unordered_movie = Factory :movie
    end

    it "returns movies for the user's active orders only from a particular studio" do
      @user.currently_rented_movies_for_studio(@studio1).should == [@active_movie1]
      @user.currently_rented_movies_for_studio(@studio1).should_not include(@active_movie2)

      @user.currently_rented_movies_for_studio(@studio2).should == [@active_movie2]
      @user.currently_rented_movies_for_studio(@studio2).should_not include(@active_movie1)
    end
  end
end
