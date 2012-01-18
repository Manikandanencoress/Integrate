require 'spec_helper'

describe Admin::MoviesController do
  before do
    FbGraph::Page.stub_chain(:new, :fetch).and_return(double(:fb_page, :identifier => "facebookidsdfdsf"))
  end
  render_views
  it_behaves_like "an authorization-required studio admin controller"


  describe "WYSIWYG update" do

    before do
      sign_in Factory(:admin)
      @movie = Factory.create(:movie)

    end

    it "updates the position for the 'watch now' button" do
      put :wysiwyg_update,
          :studio_id => @movie.studio_id,
          :id => @movie.id,
          :x => 2,
          :y => 99,
          :kind => 'watch_now'

      the_movie = assigns(:movie)
      the_movie.should_not be_nil
      the_movie.wysiwyg_watch_now_x.should == 2
      the_movie.wysiwyg_watch_now_y.should == 99
    end

    it "updates the position of the rental_length" do
      put :wysiwyg_update,
          :studio_id => @movie.studio_id,
          :id => @movie.id,
          :x => 122,
          :y => 53,
          :kind => 'rental_length'

      the_movie = assigns(:movie)
      the_movie.should_not be_nil
      the_movie.wysiwyg_rental_length_x.should == 122
      the_movie.wysiwyg_rental_length_y.should == 53
    end

  end


  describe "GET index" do
    let(:studio) { Factory(:studio) }

    describe "as a milyoni admin" do
      describe "rendering" do
        before do
          sign_in Factory(:admin)
        end

        it "assigns all the studio's movies as @movies" do
          movie1 = Factory :movie, :studio => studio
          movie2 = Factory :movie, :studio => studio
          another_studios_movie = Factory :movie
          get :index, :studio_id => studio.id
          assigns(:movies).should include(movie1)
          assigns(:movies).should include(movie2)
          assigns(:movies).should_not include(another_studios_movie)
        end
      end

      describe "authorization" do
        let(:request_to_make) { lambda { get :index, :studio_id => studio.id } }
        it_behaves_like "an admin authenticated action"
      end
    end

    describe "as a studio admin" do
      let(:admin_studio) { Factory :studio }
      let(:other_studio) { Factory :studio }
      let(:studio_admin) { Factory :admin, :studio => admin_studio }
      before { sign_in(studio_admin) }

      it "for the admin's studio it renders index" do
        get :index, :studio_id => admin_studio.id
        response.should be_success
        response.should render_template("index")
      end

      context "for another studio it redirects to it's " do
        it "redirects to the admin's studio's movie page" do
          get :index, :studio_id => other_studio.id
          response.should_not be_success
          response.should redirect_to(admin_studio_path(admin_studio))
        end
      end
    end
  end

  describe "GET show" do
    let(:movie) { Factory :movie }
    let(:request_to_make) do
      lambda {
        get :show, :id => movie.id, :studio_id => movie.studio.id
      }
    end

    it_behaves_like "an admin authenticated action"

    context "when authorized" do
      before do
        sign_in Factory(:admin)
      end

      context "assigning instance variables" do
        before do
          request_to_make.call
          response.should be_success
        end

        it "assings the movie and studio" do
          assigns(:movie).should == movie
          assigns(:studio).should == movie.studio
        end

        it "assigns variables necessary to preview the movies/show page" do
          assigns(:restrict_age).should == false
        end

        it "assigns variables necessary to preview the orders/show page" do
          assigns(:show_facebook_feed_dialog).should == false
          assigns(:ip_can_watch_movie).should == true
        end
      end

      it "displays the Rendered version of facebook_share_text" do
        movie.update_attributes(:title => "Weekend at Bernie's", :facebook_share_text => "Watch {{title}} for whacky 80's Hijinx")
        request_to_make.call
        response.body.should match("Watch Weekend at Bernie's for whacky 80's Hijinx")
      end
    end
  end


  describe "GET new" do
    let(:studio) { Factory(:studio) }
    let(:request_to_make) do
      lambda { get :new, :studio_id => studio }
    end
    it_behaves_like "an admin authenticated action"

    it "assigns a new movie as @movie" do
      sign_in Factory(:admin)
      request_to_make.call
      assigns(:movie).should be_new_record
      assigns(:studio).should == studio
    end

    it "creates a new associated skin for @movie" do
      sign_in Factory(:admin)
      request_to_make.call
    end
  end

  describe "GET edit" do
    let(:movie) { Factory(:movie) }
    let(:studio) { movie.studio }
    let(:request_to_make) do
      lambda { get :edit, :studio_id => studio, :id => movie.id }
    end
    it_behaves_like "an admin authenticated action"

    it "assigns the requested movie as @movie" do
      sign_in Factory(:admin)
      request_to_make.call
      assigns(:movie).should == movie
      assigns(:studio).should == studio
    end
  end

  describe "POST create" do
    let(:studio) { Factory(:studio) }
    let(:request_to_make) do
      movie_params = Factory.build(:movie).attributes
      lambda { post :create, :movie => movie_params, :studio_id => studio.id }
    end

    it_behaves_like "an admin authenticated action"

    context "with authorization" do
      before { sign_in Factory(:admin) }

      describe "with valid params" do
        it "assigns a newly created movie as @movie" do
          request_to_make.should change { studio.reload.movies.length }.from(0).to(1)
          assigns(:movie).should == studio.reload.movies.last
        end

        it "creates a skin for the movie" do
          request_to_make.call
          assigns(:movie).skin.should be_present
          assigns(:movie).skin.should_not be_new_record
        end

        it "redirects to the created movie" do
          request_to_make.call
          response.should redirect_to(admin_studio_movie_url(studio, studio.movies.last))
        end
      end

      describe "with invalid params" do
        before { post :create, :studio_id => studio.id, :movie => {'title' => 'not enough params'} }
        it "assigns a newly created but unsaved movie as @movie" do
          assigns(:movie).should be_new_record
        end

        it "re-renders the 'new' template" do
          response.should render_template("new")
        end
      end
    end
  end

  describe "PUT update" do
    let(:movie) { Factory :movie }
    let(:movie_params) { movie.attributes }
    let(:studio) { movie.studio }
    let(:request_to_make) do
      lambda {
        put :update, :id => movie.id, :movie => movie_params, :studio_id => studio.id
      }
    end

    it_behaves_like "an admin authenticated action"

    context "with authorization" do
      before { sign_in Factory(:admin) }

      describe "with valid params" do
        before { movie_params[:title] = "Totally New Title" }

        it "updates the requested movie" do
          request_to_make.should change { movie.reload.title }.to("Totally New Title")
        end

        it "assigns the requested movie as @movie" do
          request_to_make.call
          assigns(:movie).should == movie
        end

        it "redirects to the movie" do
          request_to_make.call
          response.should redirect_to([:admin, studio, movie])
        end
      end

      describe "with invalid params" do
        before do
          bad_params = movie_params
          bad_params[:price] = ""
          put :update, :id => movie.id, :movie => bad_params, :studio_id => studio.id
        end

        it "assigns the movie as @movie" do
          assigns(:movie).should == movie
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end
  end

  describe "DELETE destroy" do
    let(:movie) { Factory :movie }
    let(:studio) { movie.studio }
    let(:request_to_make) do
      lambda { delete :destroy, :id => movie.id, :studio_id => movie.studio.id }
    end

    it_behaves_like "an admin authenticated action"

    context "with valid auth" do

      before { sign_in Factory(:admin) }
      it "destroys the requested  movie" do
        studio.movies.should == [movie]
        request_to_make.call
        studio.movies.reload.should be_empty
      end

      it "redirects to the admin_movies list" do
        request_to_make.call
        response.should redirect_to(admin_studio_movies_url(movie.studio))
      end
    end
  end

end