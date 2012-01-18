class Admin::StreamsController < ApplicationController
  layout "admin"
  def index
    @movie = Movie.find params[:movie_id]
    @studio = @movie.studio
    @streams = Stream.find(:all,:conditions=>["movie_id=?",@movie.id])
  end

  
  def show
    @stream = Stream.find(params[:id])
  end

  def new
    @movie = Movie.find params[:movie_id]
    @studio = @movie.studio
    @stream = Stream.new
    @streams = Stream.find(:all,:conditions=>["movie_id=?",@movie.id])
  end

  def edit
    @movie = Movie.find params[:movie_id]
    @studio = @movie.studio
    @stream = Stream.find(params[:id])
    @streams = Stream.find(:all,:conditions=>["movie_id=?",@movie.id])
  end

  def create
  
    params[:stream][:movie_id]=params[:movie_id]
    
    @stream = Stream.new(params[:stream])
    if @stream.save
      redirect_to(new_admin_studio_movie_stream_path(@studio,@movie), :notice => 'Stream was successfully created.') 
    else
      @movie = Movie.find(params[:movie_id])
      @studio = @movie.studio
      @streams = Stream.find(:all,:conditions=>["movie_id=?",@movie.id])
      respond_to do |format|
       format.html { render :action => "new" }  
       #render new_admin_studio_movie_stream_path(@studio,@movie,params[:stream])
       end
    end
  
  end
  
  def update
    @stream = Stream.find(params[:id])
    params[:stream][:movie_id]=params[:movie_id]
      if @stream.update_attributes(params[:stream])
        redirect_to(new_admin_studio_movie_stream_path(@studio,@movie), :notice => 'Stream was successfully updated.') 
      else
          @movie = Movie.find(params[:movie_id])
          @studio = @movie.studio
          @streams = Stream.find(:all,:conditions=>["movie_id=?",@movie.id])
        respond_to do |format|
         format.html { render :action => "edit" }  
         #render new_admin_studio_movie_stream_path(@studio,@movie,params[:stream])
         end
      end
  end
  
  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy
    redirect_to(new_admin_studio_movie_stream_path(@studio,@movie), :notice => 'Stream was successfully deleted.') 
  end
end
