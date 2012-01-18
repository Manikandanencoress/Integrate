require 'spec_helper'

describe Filter::StudioUser do
  let(:studio) { Factory(:studio) }
  let(:movie) { Factory(:movie, :studio => studio) }
  let(:from_date) { Time.utc(2010, 1, 1) }
  let(:to_date) { Time.now.utc }

  describe "initialization" do
    it "should set purchasers_only from initialization params" do
      Filter::StudioUser.new(studio,movie,from_date,to_date,:purchasers_only => true).purchasers_only.should be_true
    end

    it "should use value_to_boolean magic to properly parse the purchasers_only checkbox form value" do
      Filter::StudioUser.new(studio,movie,from_date,to_date,:purchasers_only => "0").purchasers_only.should be_false
      Filter::StudioUser.new(studio,movie,from_date,to_date,:purchasers_only => "1").purchasers_only.should be_true
    end
  end

  context "user scopes" do
    let(:this_studio_order_user) { Factory(:user, :name => "this studio order") }
    let(:other_studio_order_user) { Factory(:user, :name => "other studio order") }

    def create_studio_order(options ={})
      Factory(:settled_order, options.merge(:user => this_studio_order_user, :movie => movie))
    end

    def create_other_studio_order
      Factory(:settled_order, :user => other_studio_order_user)
    end

    let(:this_studio_visit_user) { Factory(:user, :name => "this studio visit") }
    let(:other_studio_visit_user) { Factory(:user, :name => "other studio visit") }

    def visit_studio_movie
      Factory(:purchase_visit, :user => this_studio_visit_user, :movie => movie)
    end

    def visit_other_studio_movie
      Factory(:purchase_visit, :user => other_studio_visit_user)
    end

    describe "#fetch_users" do
      before do
        create_studio_order
        create_other_studio_order
        visit_studio_movie
        visit_other_studio_movie
      end

      context("without purchasers only") do
        let(:users) { Filter::StudioUser.new(studio,movie,from_date,to_date,{}).fetch_users! }

        it "should return all users who have visited a studio movie, or order the movie" do
          users.should include(this_studio_order_user)
          users.should include(this_studio_visit_user)
          users.should_not include(other_studio_order_user)
          users.should_not include(other_studio_visit_user)
        end

        it "should return normal user objects" do
          users.first.should respond_to(:name)
          users.first.should_not respond_to(:orders_count)
          users.first.should_not respond_to(:page_visits_count)
        end
      end

      context("with purchasers only") do
        let(:users) { Filter::StudioUser.new(studio,movie,from_date,to_date,{:purchasers_only => true}).fetch_users! }

        it "should return all users who have visited a studio movie, or order the movie" do
          users.should include(this_studio_order_user)
          users.should_not include(this_studio_visit_user)
          users.should_not include(other_studio_order_user)
          users.should_not include(other_studio_visit_user)
        end

        it "should return normal user objects" do
          users.first.should respond_to(:name)
          users.first.should_not respond_to(:orders_count)
          users.first.should_not respond_to(:page_visits_count)
        end
      end
    end

    describe "#orders_count_users" do
      it "should return users that have orders from the studio" do
        create_studio_order
        create_other_studio_order
        users = Filter::StudioUser.new(studio,movie,from_date,to_date,{}).orders_count_users
        users.should include(this_studio_order_user)
        users.should_not include(other_studio_order_user)
      end

      it "should returns special user objects that have their settled orders count as orders_count" do
        this_studio_order_user.respond_to?(:orders_count).should be_false
        create_studio_order(:status => :placed)
        create_studio_order(:status => :settled)
        create_studio_order(:status => :disputed)
        create_studio_order(:status => :refunded)
        users = Filter::StudioUser.new(studio,movie,from_date,to_date,{}).orders_count_users
        this_studio_order_user.should == users.first
        users.first.orders_count.to_i.should == 3
      end
    end

    describe "#page_visit_count_users" do
      it "should return users that have orders from the studio" do
        visit_studio_movie
        visit_other_studio_movie
        users = Filter::StudioUser.new(studio,movie,from_date,to_date,{}).page_visit_count_users
        users.should include(this_studio_visit_user)
        users.should_not include(other_studio_visit_user)
      end

      it "should returns special user objects that have their settled orders count as orders_count" do
        this_studio_visit_user.respond_to?(:page_visits_count).should be_false
        3.times { visit_studio_movie }
        users = Filter::StudioUser.new(studio,movie,from_date,to_date,{}).page_visit_count_users
        this_studio_visit_user.should == users.first
        users.first.page_visits_count.to_i.should == 3
      end
    end
  end
end