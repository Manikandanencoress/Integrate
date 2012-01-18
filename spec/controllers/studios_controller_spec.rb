
require 'spec_helper'

describe StudiosController do

  describe "GET #show" do
    it 'should redirect to studios/:id/movies with the signed facebook request' do
      studio = Factory(:studio)
      get :show, :id => studio.id, :signed_request => 'foo'
      response.should redirect_to(studio_movies_path(studio, :signed_request => 'foo'))
    end
  end
end
