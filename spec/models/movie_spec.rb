require 'spec_helper'

describe Movie do
  describe "attributes" do
    it "can be created" do
      movie = Factory :movie, :title => "Harry Potter"
      movie.should be_present
      movie.title.should == "Harry Potter"
    end
  end

  describe "validations" do
    before do
      @movie = Movie.new
      @movie.valid?
    end

    %w{ price
        studio
        font_color_help
        popup_bk_color_1
        popup_bk_color_2
        button_color_gradient_1
        button_color_gradient_2
    }.each do |i|
      it "validates presence of #{i}" do
        @movie.should have(1).error_on(i.to_sym)
      end
    end

    it "validates cdn_path and video_file_path on Warner movies" do
      movie = Factory(:studio).movies.new
      movie.studio.update_attributes(:name => 'Warner', :player => 'warner')
      movie.valid?
      %w{
        cdn_path
        video_file_path
      }.each do |i|
        movie.should have(1).error_on(i.to_sym)
      end
      movie.studio.update_attributes(:name => 'FUNamation', :player => 'milyoni')
      movie.valid?
      %w{
        cdn_path
        video_file_path
      }.each do |i|
        movie.should have(0).error_on(i.to_sym)
      end
    end

    it "validates brightcove_movie_id on non-Warner movie" do
      movie = Factory(:studio).movies.new
      movie.studio.update_attributes(:name => 'Warner')
      movie.valid?
      movie.should have(0).error_on(:brightcove_movie_id)
      movie.studio.update_attributes(:name => 'FUNamation', :player => 'brightcove')
      movie.update_attribute(:brightcove_movie_id, nil)
      movie.valid?
      movie.should have(1).error_on(:brightcove_movie_id)
    end

    it "validates the fb_comments_color is light or dark" do
      movie = Movie.new
      movie.should have(0).errors_on(:fb_comments_color)
      movie.fb_comments_color = 'light'
      movie.should have(0).errors_on(:fb_comments_color)
      movie.fb_comments_color = 'dark'
      movie.should have(0).errors_on(:fb_comments_color)
      movie.fb_comments_color = 'starfish'
      movie.should have(1).errors_on(:fb_comments_color)
    end

    describe "#paypal_price" do

      it "gives back paypal's format" do
        movie = Factory(:movie, :price => 30)
        movie.paypal_price.should == 300
      end

    end


    describe ":released" do
      it "doesn't validate when released is false" do
        movie = Factory(:movie)
        movie.skin.stub(:complete?).and_return(false)

        movie.released = false
        movie.save
        movie.should have(0).errors_on(:released)
      end

      it "validates true when movie is complete" do
        movie = Factory(:movie, :released => false)
        movie.skin.stub(:complete?).and_return(true)

        movie.should be_complete
        movie.released = true
        movie.save
        movie.should be_valid
      end

      it "validates false when movie is incomplete" do
        movie = Factory(:movie, :released => false)
        movie.skin.stub(:complete?).and_return(false)

        movie.released = true
        movie.save
        movie.should_not be_valid
        movie.should have(1).error_on(:released)
      end
    end
  end

  describe "associations" do
    it "should belong_to :studio" do
      studio = Factory(:studio)
      movie = Factory.build(:movie)
      movie.studio = studio
      movie.save
      movie.reload.studio.should == studio
    end

    it "should have_many :orders" do
      Movie.reflect_on_association(:orders).macro.should == :has_many
    end

    it "should have_one :skin" do
      Movie.reflect_on_association(:skin).macro.should == :has_one
    end
  end

  #describe "movie series" do
  #  before do
  #    @hp1 = Factory :movie
  #    @hp2 = Factory :movie
  #    @hp3 = Factory :movie
  #  end
  #
  #
  #  it "knows hp1 is a series" do
  #    @hp1.titles << @hp1
  #    @hp1.titles.size.should == 1
  #  end
  #
  #
  #  it "hp1 has other series also" do
  #    @hp1.titles << @hp1
  #    @hp1.titles << @hp2
  #    @hp1.titles << @hp3
  #    @hp1.titles.size.should == 3
  #
  #    @hp1.titles.last.id.should == @hp3.id
  #  end
  #
  #end

  describe "scopes" do
    describe "viewable for user" do
      before do
        @released = Factory(:movie, :released => true)
        @unreleased = Factory(:movie, :released => false)
        Sumuru::Application.config.whitelisted_facebook_ids << '1'
      end

      it "returns all movies for a whitelisted user" do
        Movie.viewable_for_user('1').should include(@released)
        Movie.viewable_for_user('1').should include(@unreleased)
      end

      it "returns only released movies for a nonwhitelisted user" do
        Movie.viewable_for_user('2').should include(@released)
      end
    end
  end

  describe "#active_orders_for(facebook_user_id)" do
    before do
      @movie = Factory :movie
      @user = Factory(:user)
      @correct_order = Factory :order, :movie => @movie, :user_id => @user.id
      @correct_order.settle!
    end

    it "returns only the active order for a facebook user id" do
      @movie.active_orders_for(@user).should include(@correct_order)
    end

    it "does not return other movie's orders for that user id" do
      different_movie = Factory(:movie)
      @order_for_wrong_movie = Factory :order, :movie => different_movie, :user => @user
      @order_for_wrong_movie.settle!
      @movie.active_orders_for(@user).should_not include(@order_for_wrong_user)
    end

    it "does not return orders for other users" do
      @order_for_wrong_user = Factory :order, :movie => @movie
      @order_for_wrong_user.settle!
      @movie.active_orders_for(@user).should_not include(@order_for_wrong_user)
    end

    it "does not return expired orders" do
      @expired_order = Factory :order, :movie => @movie, :user => @user,
                               :rented_at => 100.days.ago, :status => 'settled'
      @movie.active_orders_for(@user).should_not include(@inactive_order)
    end

    it "does not return unsettled orders" do
      @unsettled_order = Factory :order, :movie => @movie, :user => @user
      @movie.active_orders_for(@user).should_not include(@unsettled_order)
    end

  end

  describe "#facebook_fan_page_url=" do
    let(:movie) { Factory.build(:movie) }

    it "should lookup the fanpage id for crazy urls" do
      VCR.use_cassette :the_notebook_facebook_url, :record => :new_episodes do
        movie.facebook_fan_page_url= "http://www.facebook.com/TheNotebookMovie"
        movie.save
        movie.reload
        movie.facebook_fan_page_url.should == "http://www.facebook.com/TheNotebookMovie"
        movie.facebook_fan_page_id.should == "204558349574109"
      end
    end

    it "should get the id off old skool urls" do
      movie.facebook_fan_page_url= "http://www.facebook.com/pages/The-Notebook/108388605855893"
      movie.save
      movie.reload
      movie.facebook_fan_page_url.should == "http://www.facebook.com/pages/The-Notebook/108388605855893"
      movie.facebook_fan_page_id.should == "108388605855893"
    end

    describe "when passing it a blank string" do
      before do
        movie.facebook_fan_page_id = 123123123
      end

      it "should set the facebook_fan_page_id to blank" do
        movie.facebook_fan_page_url = ''
        movie.facebook_fan_page_id.should == nil
        movie.facebook_fan_page_url = nil
        movie.facebook_fan_page_id.should == nil
      end
    end
  end


  describe "#facebook_redirect_uri" do
    it { should respond_to(:facebook_redirect_uri) }
    it "should derive it's facebook url from it's application" do
      studio = Factory(:studio, :facebook_canvas_page => 'http://example.com/foo/')
      movie = Factory(:movie, :studio => studio)
      movie.facebook_redirect_uri.should =~ /^http:\/\/example.com\/foo\//
    end
    it "should end with movies/:id" do
      movie = Factory(:movie, :id => 1)
      movie.facebook_redirect_uri.should =~ /movies\/1$/
    end

  end

  describe "#media_path" do
    it "gets the media path from the WB token generator" do
      movie = Factory :movie, :cdn_path => "foo", :video_file_path => "bar"
      WbTokenGenerator::TokenGenerator.should_receive(:generate).
          with("foo", "bar").and_return('baz')
      movie.media_path.should == 'baz'
    end
  end

  describe "#viewable_for_user?" do
    let(:movie) { Factory(:movie) }
    context "movie is released" do
      before { movie.update_attribute :released, true }
      it "should return true" do
        movie.viewable_for_user?('1').should be_true
      end
    end

    context "movie is not released" do
      before { movie.update_attribute :released, false }
      context "user is not whitelisted" do
        it "should return false" do
          movie.viewable_for_user?('1').should be_false
        end
      end
      context "user is whitelisted" do
        it "should return true" do
          Sumuru::Application.config.whitelisted_facebook_ids << '1'
          movie.viewable_for_user?('1').should be_true
        end
      end
    end
  end

  describe "share texts" do
    let(:studio) { Factory :studio, :name => "Mercury Theatre" }
    let(:movie) { Factory :movie, :title => 'Citizen Kane', :studio => studio, :price => 50 }

    describe "#facebook_share_text" do
      it "should interpolate a user defined string" do
        movie.update_attributes(:facebook_share_text => "{{title}} by {{studio}} for only {{price}} money.")
        movie.facebook_share_text.should match("Citizen Kane by Mercury Theatre for only 50 money")
      end

      it "should store the text in mustached format" do
        movie.update_attributes(:facebook_share_text => "{{title}} by {{studio}} for only {{price}} money.")
        movie[:facebook_share_text].should == "{{title}} by {{studio}} for only {{price}} money."
      end
    end

    describe "#twitter_share_text" do
      it "should interpolate a user defined string" do
        movie.update_attributes(:twitter_share_text => "{{title}} by {{studio}} for only {{price}} money.")
        movie.twitter_share_text.should match("Citizen Kane by Mercury Theatre for only 50 money")
      end

      it "should store the text in mustached format" do
        movie.update_attributes(:twitter_share_text => "{{title}} by {{studio}} for only {{price}} money.")
        movie[:twitter_share_text].should == "{{title}} by {{studio}} for only {{price}} money."
      end
    end
  end

  describe "#report" do
    let(:movie) { Factory :movie }
    let(:utc_christmas) { Time.utc(2010, 12, 25, 12) }
    let(:one_month_before_christmas) { Time.now.change(:month => 11) }

    before do
      Timecop.freeze(utc_christmas)
      @settled_order = Factory(:settled_order, :movie => movie, :rented_at => utc_christmas)
      @unsettled_order = Factory(:order, :movie => movie)
      @old_settled_order = Factory(:settled_order, :movie => movie, :rented_at => one_month_before_christmas)
    end

    it "returns a hash with report metrics" do
      movie.report.should be_a(Hash)
    end

    context "today metrics" do
      describe ":todays_orders" do
        it "returns the number of orders from only today" do
          movie.report[:todays_orders].should == 1
        end
      end

      describe ":todays_visits" do
        before do
          2.times do
            movie.page_visits.create! :page => 'purchase',
          end
          movie.page_visits.create! :page => 'purchase', :created_at => Date.yesterday
        end
        it "returns number of visits to the purchase page today" do
          movie.report[:todays_visits].should == 2
        end
      end

      describe ":todays_watches" do
        before do
          2.times do
            movie.page_visits.create! :page => 'watch',
          end
          movie.page_visits.create! :page => 'watch', :created_at => Date.yesterday
        end
        it "returns number of visits to the purchase page today" do
          movie.report[:todays_watches].should == 2
        end
      end

      describe ":todays_conversion" do
        it "should return 0 if there are no visits" do
          movie.page_visits.count.should == 0
          movie.report[:todays_conversion].should == 0
        end

        it "should return 0 if there are no orders, but 1 visit" do
          movie.orders.destroy_all
          movie.orders.count.should == 0
          movie.page_visits.create! :page => 'purchase'
          movie.report[:cumulative_conversion].should == 0
        end

        it "should show the conversion rate for the settled orders & purchase visits for today only" do
          movie.page_visits.create! :page => 'watch'

          8.times do
            movie.page_visits.create! :page => 'purchase'
          end
          5.times do
            movie.page_visits.create! :page => 'purchase', :created_at => one_month_before_christmas
          end

          movie.report[:todays_conversion].should == 0.125
        end
      end

      describe ":todays_revenue" do
        it "should show the total number of facebook_credits_ordered today " do
          Factory(:settled_order, :rented_at => utc_christmas, :total_credits => 11, :movie => movie)
          @settled_order.update_attributes(:total_credits => 5)

          movie.report[:todays_revenue].should == 16
        end
      end
    end


    describe "when passed a date parameter" do
      before(:each) do
        Timecop.freeze utc_christmas + 3.years
      end

      context "for the month after christmas" do
        let(:generate_report) { lambda { movie.report(utc_christmas) } }

        describe ":todays_visits" do
          it "returns number of visits to the purchase page for today" do
            movie.page_visits.create! :page => 'purchase', :created_at => utc_christmas.yesterday
            2.times do
              movie.page_visits.create! :page => 'purchase', :created_at => utc_christmas
            end
            movie.page_visits.create! :page => 'purchase', :created_at => utc_christmas.tomorrow

            movie.page_visits.create! :page => 'purchase'
            movie.page_visits.create! :page => 'foo'
            generate_report.call[:todays_visits].should == 2
          end
        end

        describe ":cumulative_visits" do
          it "returns number of visits to the purchase page on or before the given date (ignores other pages)" do
            two_weeks_before_xmas = utc_christmas - 2.weeks
            3.times do
              movie.page_visits.create! :page => 'purchase', :created_at => two_weeks_before_xmas
            end
            movie.page_visits.create! :page => 'purchase', :created_at => utc_christmas.tomorrow
            movie.page_visits.create! :page => 'foo', :created_at => utc_christmas
            generate_report.call[:cumulative_visits].should == 3
          end
        end

        describe ":todays_watches" do
          it "returns number of visits to the purchase page today" do
            movie.page_visits.create! :page => 'watch', :created_at => utc_christmas.yesterday
            3.times do
              movie.page_visits.create! :page => 'watch', :created_at => utc_christmas
            end
            movie.page_visits.create! :page => 'watch', :created_at => utc_christmas.tomorrow

            movie.page_visits.create! :page => 'watch'
            movie.page_visits.create! :page => 'foo'
            generate_report.call[:todays_watches].should == 3
          end
        end

        describe ":cumulative_watches" do
          it "returns number of visits to the purchase page (ignores other pages)" do
            Timecop.freeze utc_christmas - 2.weeks do
              3.times { movie.page_visits.create! :page => 'watch' }
            end

            movie.page_visits.create! :page => 'watch'
            movie.page_visits.create! :page => 'foo'
            generate_report.call[:cumulative_watches].should == 3
          end
        end

        describe ":todays_orders" do
          it "returns number of settled orders for today as key :todays_orders" do
            tomorrows = Factory(:settled_order, :movie => movie, :rented_at => utc_christmas.tomorrow)
            yesterdays = @settled_order.update_attributes(:rented_at => utc_christmas.yesterday)
            generate_report.call[:todays_orders].should be(0)
            todays = Factory(:settled_order, :movie => movie, :rented_at => utc_christmas)
            generate_report.call[:todays_orders].should be(1)
          end
        end

        describe ":cumulative_orders" do
          it "returns number of settled orders for all time as key :cumulative_orders" do
            Timecop.freeze utc_christmas - 2.weeks { Factory(:settled_order, :movie => movie) }
            Factory(:settled_order, :movie => movie, :rented_at => utc_christmas + 2.weeks)
            @settled_order.update_attributes(:rented_at => utc_christmas + 2.weeks)
            generate_report.call[:cumulative_orders].should be(1)
          end
        end

        describe ":cumulative_conversion" do
          before do
            movie.orders.destroy_all
            movie.orders.count.should == 0
          end

          it "should return 0 if there are no visits" do
            movie.page_visits.count.should == 0
            generate_report.call[:cumulative_conversion].should == 0
          end

          it "should return 0 if there are no orders, but 1 visit" do
            Timecop.freeze(utc_christmas + 2.weeks) { movie.page_visits.create! :page => 'purchase' }
            generate_report.call[:cumulative_conversion].should == 0
          end

          it "should show the conversion rate for the settled orders and purchase visits" do
            Timecop.freeze one_month_before_christmas { 5.times { movie.page_visits.create! :page => 'purchase' } }
            Timecop.freeze(utc_christmas - 2.weeks) do
              2.times { movie.page_visits.create! :page => 'purchase' }
              movie.page_visits.create! :page => 'watch'
              Factory(:settled_order, :movie => movie)
            end

            generate_report.call[:cumulative_conversion].should == 0.5
          end
        end

        describe ":todays_revenue" do
          it "should return the total credits of all orders for this movie for today" do
            Factory(:settled_order, :rented_at => utc_christmas.yesterday, :total_credits => 200, :movie => Factory(:movie))
            Timecop.freeze utc_christmas do
              Factory(:settled_order, :total_credits => 4, :movie => movie)
              Factory(:settled_order, :total_credits => 6, :movie => movie)
            end
            @settled_order.update_attributes(:rented_at => utc_christmas.tomorrow, :total_credits => 20000)
            generate_report.call[:cumulative_revenue].should == 10
          end
        end

        describe ":cumulative_revenue" do
          it "should return the total credits of all orders for this movie" do
            Timecop.freeze utc_christmas - 2.weeks do
              other_movie = Factory(:settled_order, :rented_at => utc_christmas, :total_credits => 200, :movie => Factory(:movie))
              Factory(:settled_order, :total_credits => 4, :movie => movie)
              Factory(:settled_order, :total_credits => 6, :movie => movie)
            end
            @settled_order.update_attributes(:rented_at => utc_christmas + 2.weeks, :total_credits => 20000)
            generate_report.call[:cumulative_revenue].should == 10
          end
        end
      end

      context "for all time" do
        describe ":cumulative_visits" do
          it "returns number of visits to the purchase page (ignores other pages)" do
            2.times { movie.page_visits.create! :page => 'purchase' }
            movie.page_visits.create! :page => 'foo'
            movie.report[:cumulative_visits].should == 2
          end
        end

        describe ":cumulative_watches" do
          it "returns number of visits to the purchase page (ignores other pages)" do
            2.times { movie.page_visits.create! :page => 'watch' }
            movie.page_visits.create! :page => 'foo'
            movie.report[:cumulative_watches].should == 2
          end
        end

        describe ":cumulative_orders" do
          it "returns number of settled orders for all time as key :cumulative_orders" do
            movie.report[:cumulative_orders].should be(2)
          end
        end

        describe ":cumulative_conversion" do
          it "should return 0 if there are no visits" do
            movie.page_visits.count.should == 0
            movie.report[:cumulative_conversion].should == 0
          end

          it "should return 0 if there are no orders, but 1 visit" do
            movie.orders.destroy_all
            movie.orders.count.should == 0
            movie.page_visits.create! :page => 'purchase'
            movie.report[:cumulative_conversion].should == 0
          end

          it "should show the conversion rate for the settled orders and purchase visits" do
            5.times { movie.page_visits.create! :page => 'purchase' }
            5.times { movie.page_visits.create! :page => 'purchase', :created_at => one_month_before_christmas }
            movie.page_visits.create! :page => 'watch'

            movie.report[:cumulative_conversion].should == 0.2
          end
        end

        describe ":cumulative_revenue" do
          it "should return the total credits of all orders for this movie" do
            order_for_other_movie = Factory(:settled_order, :rented_at => utc_christmas,
                                            :total_credits => 2, :movie => Factory(:movie))
            Factory(:settled_order, :rented_at => utc_christmas, :total_credits => nil, :movie => movie)
            @settled_order.update_attributes(:total_credits => 22)
            @old_settled_order.update_attributes(:total_credits => 13)

            movie.report[:cumulative_revenue].should == 35
          end
        end
      end
    end
  end

  describe "as json" do
    it "shouldn't raise an error" do
      movie = Factory(:movie)
      lambda { movie.as_json }.should_not raise_error
      lambda { movie.to_json }.should_not raise_error
    end
  end

  describe "#restricted_for?(:user)" do
    let(:user) { Factory.build (:user) }
    let(:movie) { Factory.build (:movie) }
    it "should return false if the movie is not restricted" do
      movie.update_attribute :age_restricted, false
      movie.restricted_for?(user).should be_false
    end

    context "movie is restricted" do
      before do
        movie.update_attribute :age_restricted, true
      end
      it "should return true when the user is too young" do
        user.birthday = Date.yesterday
        movie.restricted_for?(user).should be_true
      end
      it "should return false when the user is old enough" do
        user.birthday = 20.years.ago.to_date
        movie.restricted_for?(user).should be_false
      end
    end
  end

  describe "#generate_discount_link" do
    let(:movie) { Factory.build(:movie, :discount_redirect_link => 'http://www.go.com') }
    it "should generate a link with the discount key" do
      link = movie.generate_discount_link
      link.should =~ /discount_key/
      characters = movie.discount_redirect_link + "?discount_key=12345"
      link.length.should > characters.length
    end
  end

  describe "#fb_comments_color" do
    it "should default to 'light'" do
      Movie.new.fb_comments_color.should == 'light'
    end

    it "should respect the writer in-memory" do
      movie = Movie.new
      movie.fb_comments_color = 'dark'
      movie.fb_comments_color.should == 'dark'
    end
  end


  describe "genres" do
    let(:genred_object) { Factory(:movie) }
    let(:movie) { Factory(:movie) }

    it_should_behave_like "an object that's tagged with genre"

    describe "#genre" do
      it "should say the name of the first genre" do
        movie.genre.should be_nil
        movie.update_attribute(:genre_list, "intense teen dramadies")
        movie.reload.genre.should == "intense teen dramadies"
      end
    end

    describe "#genre=" do
      it "should set the genre" do
        movie.genre= "socially awkward penguin films"
        movie.genre.should == "socially awkward penguin films"
        movie.save
        movie.reload.genre.should == "socially awkward penguin films"
      end
    end
  end
end
