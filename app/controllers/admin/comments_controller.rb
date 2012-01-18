class Admin::CommentsController < AdminController
  inherit_resources
  actions :show, :update, :edit, :destroy, :moderate
  belongs_to :movie, :singleton => true

  def index
    @studio = Studio.find params[:studio_id]
    @movie = Movie.find params[:movie_id]
    @comments = Comment.where(:movie_id => params[:movie_id]).
        paginate(:page => params[:page], :per_page => 10).
        order('id DESC')
  end

  def edit
    @studio = Studio.find params[:studio_id]
    @movie = Movie.find params[:movie_id]
  end

  def moderate
    list = params[:list].split(",")
    list.delete_at(0)
    list.collect { |id| Comment.find(id).destroy }
    render :json => {:success => "Destroyed Successfully!"}
  end


end