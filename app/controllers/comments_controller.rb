class CommentsController < InheritedResources::Base
  belongs_to :movie
  skip_before_filter :validate_geo_restriction
  respond_to :json
  actions :index, :show

  def create
    @movie = Movie.find(params[:movie_id])
    @studio = @movie.studio
    user = load_facebook_user
    comment_params = params[:comment].merge({:user_id => user.id})
    comment = @movie.comments.create(comment_params)
    render :json => comment
  end

  #def index
  #  result = []
  #  @prev_num = 0
  #  num_array = []
  #  comments = Movie.find(params[:movie_id]).comments
  #  array = comments.collect(&:commented_at).uniq
  #  array.each do |n|
  #    if n >= @prev_num + 4
  #      num_array << n
  #      @prev_num = n + 4
  #    end
  #  end
  #  num_array.each do |element|
  #    result << Comment.find_all_by_movie_id_and_commented_at(params[:movie_id], element).sort_by(&:id).first(3)
  #  end
  #  result << Comment.last(3)
  #  result.uniq!
  #  result.flatten!
  #  render :json => result
  #end


  def stack
    #comment = Comment.find params[:id]
    #other_comments = Comment.find :all,
    #                              :conditions => [ :movie_id => comment.movie_id,
    #:created_at => [comment.created_at - 5 .. comment.created_at + 5]]
    #return html_stack
    #respond_to do |format|
    #   format.json { head :ok }
    # end

    render :json => "<h1>Hirow from Rails</h1>"
  end

  def destroy
    comment = Comment.find params[:id]
    movie_id = comment.movie_id
    studio_id = comment.movie.studio_id
    comment.destroy
    flash[:notice] = "Comment deleted"
    redirect_to edit_admin_studio_movie_comments_path(studio_id, movie_id)
  end


end