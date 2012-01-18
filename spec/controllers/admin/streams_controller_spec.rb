require 'spec_helper'

describe Admin::StreamsController do
 
  let(:studio_admin) { Factory(:studio_admin) }
  let(:movie) {Factory(:movie)}
  let(:studio) { studio_admin.studio }
  
  def mock_stream(stubs={})
    (@mock_stream ||= mock_model(Stream).as_null_object).tap do |stream|
      stream.stub(stubs) unless stubs.empty?
    end
  end
  
  describe "GET new" do
    it "assigns a new stream as @stream" do
      Stream.stub(:new) { mock_stream }
      get :new,:movie_id => movie.id ,:studio_id=>studio.id
      assigns(:stream).should be(mock_stream)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested stream as @stream" do
      Stream.stub(:find,:conditions=>["id=37 and movie_id=?",movie.id]){ mock_stream }
      get :edit, :id => "37",:movie_id => movie.id ,:studio_id=>studio.id
      assigns(:stream).should be(mock_stream)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created stream as @stream" do
        Stream.stub(:new).with({'these' => 'params','movie_id'=>movie.id}) { mock_stream(:save => true) }
        post :create, :movie_id => movie.id ,:studio_id=>studio.id, :stream => {'these' => 'params','movie_id'=>movie.id}
        assigns(:stream).should be(mock_stream)
      end

      it "redirects to the created stream" do
        Stream.stub(:new) { mock_stream(:save => true) }
        post :create, :stream => {},:movie_id => movie.id ,:studio_id=>studio.id
        response.should redirect_to(new_admin_studio_movie_stream_path(studio,movie))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved stream as @stream" do
        Stream.stub(:new).with({'these' => 'params','movie_id'=>movie.id}) { mock_stream(:save => false) }
        post :create,:movie_id => movie.id ,:studio_id=>studio.id,:stream => {'these' => 'params','movie_id'=>movie.id}
        assigns(:stream).should be(mock_stream)
      end
      it "re-renders the 'new' template" do
        Stream.stub(:new) { mock_stream(:save => false) }
        post :create, :stream => {},:movie_id => movie.id ,:studio_id=>studio.id
        response.should render_template("new")
      end
    end
    
  end
 
  
  describe "DELETE destroy" do
    it "destroys the requested stream" do
      Stream.should_receive(:find).with("37") { mock_stream }
      mock_stream.should_receive(:destroy)
      delete :destroy, :id => "37",:movie_id => movie.id ,:studio_id=>studio.id
    end

    it "redirects to the streams list" do
      Stream.stub(:find) { mock_stream }
      delete :destroy, :id => "1",:movie_id => movie.id ,:studio_id=>studio.id
      response.should redirect_to(new_admin_studio_movie_stream_path(studio,movie))
    end
  end

end
