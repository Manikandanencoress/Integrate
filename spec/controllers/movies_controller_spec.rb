require 'spec_helper'

describe MoviesController do
  render_views



  describe "GET index" do
    before do
      @studio1 = Factory :studio, :facebook_canvas_page => "http://www.fb.com"
      @studio2 = Factory :studio, :facebook_canvas_page => "http://www.fb.com"
      @zanzabar_hotel = Factory :movie, :studio => @studio1, :title => 'Zanzabar Hotel'
      @adventure_island = Factory :movie, :studio => @studio1, :title => 'Adventure Island'
    end

    it "should display all movies from a specific studio in alphabetical order" do
      friendship_surprise = Factory(:movie, :studio => @studio1, :title => "Friendship Surprise: My Little Ponies take on Gargamel")
      garfield = Factory(:movie, :studio => @studio1, :title => "garfield needs your money")
      get :index, :studio_id => @studio1.id
      movies = assigns(:movies).flatten
      movies.should == [@adventure_island, friendship_surprise, garfield, @zanzabar_hotel]
    end

    it "shouldn't display movies from a different studio" do
      get :index, :studio_id => @studio2.id
      movies = assigns(:movies).flatten
      movies.should_not include(@zanzabar_hotel)
      movies.should_not include(@adventure_island)
    end

    describe "with a facebook user" do
      before do
        @facebook_user = Factory(:user, :facebook_user_id => 'my.user.id')
        User.should_receive(:find_or_create_from_fb_graph).and_return(@facebook_user)
      end

      it "should display the template" do
        @facebook_user.stub!(:currently_rented_movies_for_studio).and_return([@zanzabar_hotel])
        get :index, :studio_id => @studio1.id
        assigns(:studio).should == @studio1
        assigns(:active_rentals).should == [@zanzabar_hotel]
        assigns(:movies).should_not include(@zanzabar_hotel)
        response.should be_success
        response.should render_template(:index)
      end

      describe "unreleased movies" do
        before do
          @unreleased_movie = Factory(:movie, :released => false, :studio => @studio1)
        end

        context "user is not whitelisted" do
          it "should not show unreleased movies" do
            get :index, :studio_id => @studio1.id
            assigns(:movies).flatten.should_not include(@unreleased_movie)
          end
        end

        #context "user is whitelisted" do
        #  it "should show unreleased movies" do
        #    Sumuru::Application.config.whitelisted_facebook_ids << @facebook_user.facebook_user_id
        #    get :index, :studio_id => @studio1.id
        #    assigns(:movies).flatten.should include(@unreleased_movie)
        #  end
        #end
      end


      it "should splash redirect to index if a movie doesn't exists" do
        Movie.stub(:find_by_id).with('0').and_return(nil)
        get :show, :studio_id => @studio1.id, :id => '0'
        response.should redirect_to(studio_movies_path(@studio1))
      end
    end
  end

  describe "GET show" do
    before do
      @movie = Factory :movie
      @studio = @movie.studio
    end

    context "movie is not released" do
      before do
        @movie.update_attribute :released, false
      end

      context "user is not white listed to see unreleased movies" do
        it "should redirect to index" do
          get :show, :id => @movie.id, :studio_id => @studio.id
          response.status.should == 302
          response.should redirect_to(studio_movies_path(@studio))
        end
      end

      context "user is whitelisted to see unreleased movies" do
        before do
          Sumuru::Application.config.whitelisted_facebook_ids << 'my.user.id'
          @facebook_user = Factory(:user, :facebook_user_id => 'my.user.id')
          User.stub(:find_or_create_from_fb_graph).and_return(@facebook_user)
        end

        it "should show the movie" do
          get :show, :id => @movie.id, :studio_id => @studio.id
          response.status.should == 200
        end
      end
    end

    context "when our fb_auth doesnt have a user" do
      before do
        fb_mock = double('fb_auth')
        fb_mock.stub!(:user).and_return(nil)
        controller.stub!(:facebook).and_return(fb_mock)

        get :show, :id => @movie.id, :studio_id => @studio.id
      end

      it "renders the splash template" do
        response.should render_template(:splash)
      end
    end


    context "authenicated with a user" do

      describe "page rendering" do
        before do
          @facebook_user = Factory(:user, :facebook_user_id => 'my.user.id')
          User.should_receive(:find_or_create_from_fb_graph).and_return(@facebook_user)
        end

        context "with a non-expired order for this movie & user" do
          describe "when it redirects to the order path" do
            before do
              @order = Factory :order, :movie => @movie, :user => @facebook_user
              @order.settle!
            end

            it "should pass along the signed request" do
              FbGraph::Auth.stub(:new).and_return("facebook object!")
              get :show, :id => @movie.id, :signed_request => "foo", :studio_id => @studio.id
              path = studio_movie_order_path(@movie.studio, @movie, @order, :signed_request => "foo")
              response.should redirect_to(path)
            end
            it "should pass along the signed request" do
              get :show, :id => @movie.id, :show_facebook_feed_dialog => "foo", :studio_id => @studio.id
              path = studio_movie_order_path(@movie.studio, @movie, @order, :show_facebook_feed_dialog => "foo")
              response.should redirect_to(path)
            end
          end
        end

        context "with no order" do

          it "renders the purchase template" do
            get :show, :id => @movie.id, :studio_id => @studio.id
            assigns(:movie).should == @movie
            response.should render_template(:purchase)
          end

          it "tracks that a user visited" do
            expect {
              get :show, :id => @movie.id, :studio_id => @studio.id
            }.to change {
              @movie.page_visits.where(:page => 'purchase', :user_id => @facebook_user.id).count
            }.by(1)
          end
        end
      end
    end
  end


  describe "GET #fan_pages" do
    let(:studio) { Factory(:studio) }
    before do
      data = {
          "page" => {
              "id" => "123456"
          }
      }

      controller.stub_chain(:facebook, :data).and_return(data)
    end

    context "Fan page redirection exists for movie" do
      it "should redirect to that movie's show page" do
        movie = Factory(:movie, :studio => studio)
        movie.facebook_fan_page_id = "123456"
        movie.save

        get :fan_pages, :studio_id => studio.id
        response.should redirect_to(studio_movie_path(studio, movie))
      end
    end

    context "Fan page redirection exists for movies not in my studio" do
      before do
        other_studio = Factory(:studio)
        other_movie = Factory(:movie, :studio => other_studio)
        other_movie.facebook_fan_page_id = "123456"
        other_movie.save
      end
      it "should redirect to this studio's movie gallery" do
        get :fan_pages, :studio_id => studio.id
        response.should redirect_to(studio_movies_path(studio))
      end

      it "should still work for the studio that has the movie" do
        movie = Factory(:movie, :studio => studio)
        movie.facebook_fan_page_id = "123456"
        movie.save

        get :fan_pages, :studio_id => studio.id
        response.should redirect_to(studio_movie_path(studio, movie))
      end
    end

    context "Fan page redirection does not exist" do
      it 'should just render some not found text' do
        movie = Factory(:movie, :studio => studio)
        movie.facebook_fan_page_id = nil
        movie.save

        get :fan_pages, :studio_id => studio.id
        response.should redirect_to(studio_movies_path(studio))
      end
    end
  end

  describe "js api call" do
    before() do
      @studio = Factory(:studio)
      @movie = Factory(:movie, :studio => @studio)
      Factory.create(:coupon, :code => '1234', :movie => @movie)
      @facebook_user = Factory(:user, :facebook_user_id => 'my.user.id')
      User.should_receive(:find_or_create_from_fb_graph).and_return(@facebook_user)
    end

    it "returns accepted status with the right code" do
      get :check_coupon, :id => @movie.id, :studio_id => @studio.id, :code => '1234'
      c = assigns(:coupon)
      c.code.should == '1234'
      response.status.should == 200
    end

    it "returns no response if code is wrong" do
      get :check_coupon, :id => @movie.id, :studio_id => @studio.id, :code => '9999'
      response.status.should == 403
    end

  end


end