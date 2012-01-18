class StudiosController < ApplicationController
  def show
    redirect_to studio_movies_path(params[:id], :signed_request => params[:signed_request])
  end
end
