class Admin::StudiosController < AdminController
  inherit_resources
  actions :all, :except => :destroy
  before_filter :authorize_user_for_comment_stream_enabled, :only => :update

  def index
    @withmovies= []
    @withoutmovies = []
    @studios = Studio.find(:all,:order=>"name")
    @archived = Studio.find(:all,:conditions=>["name like ? ","(archive)%"],:order=>"name")
    @studios.each do| studio|
      if studio.movies.length > 0
        @withmovies << studio 
      else
        @withoutmovies << studio
      end  
    end
    
   if params[:studio] and params[:studio][:studio_id] != ""
        @studios = Studio.find(:all,:conditions=>["id=?",params[:studio][:studio_id]])
        @current_selected = params[:studio][:studio_id]        
        @combo_studios = nil
        @combo_studios = @withmovies + @withoutmovies 
        @combo_studios = @combo_studios - @archived
        @combo_studios = @combo_studios + @archived
   else
        @studios = nil
        @studios = @withmovies + @withoutmovies 
        @studios = @studios - @archived
        @studios = @studios + @archived      
        @current_selected=0
        @combo_studios = @studios
     end
  end
  
  def show
    if !current_admin.studio.present?
     redirect_to admin_studio_movies_path(params[:id]), :flash => flash
    else
     redirect_to admin_info_studios_path
    end
  end
  
  def studioinfo
    @withmovies= []
    @withoutmovies = []
    @studios = Studio.find(:all,:order=>"name")
    @archived = Studio.find(:all,:conditions=>["name like ? ","(archive)%"],:order=>"name")
    @studios.each do| studio|
      if studio.movies.length > 0
        @withmovies << studio 
      else
        @withoutmovies << studio
      end  
    end
    
   if params[:studio] and params[:studio][:id] != ""
        @studio = Studio.find(:first,:order=>"name", :conditions =>["id=?",params[:studio][:id].to_i])
        @current_selected = params[:studio][:id]        
        @combo_studios = nil
        @combo_studios = @withmovies + @withoutmovies 
        @combo_studios = @combo_studios - @archived
        @combo_studios = @combo_studios + @archived
   else
        @studios = nil
        @studios = @withmovies + @withoutmovies 
        @studios = @studios - @archived
        @studios = @studios + @archived
        @combo_studios = @studios
        @studio = @studios[0]
        @current_selected = 0
   end   
  end
  
  def studiodetail
    @studio = Studio.find(params[:id])    
    @current_selected = @studio.id
  end
  
  def load_movie
    begin
     @studio = Studio.find(params[:id])
     @movies = Movie.find(:all,:select=>"id,title",:conditions => ["studio_id = ?", params[:id]] ,:order=>"title" )
      respond_to do |format|
        format.js
      end
    rescue Exception => e
    end
  end
  
  def studiolist
    @studios = Studio.find(:all, :order=>"name")
    if params[:studio] and params[:studio][:id]!=""     
      @studio = Studio.find(params[:studio][:id]) 
      @current_selected = @studio.id
      @movies = Movie.find(:all, :conditions => ["studio_id = ?",params[:studio][:id]], :order=>"title")
    else
      @current_selected = ""
    end
    @selected_menu = "Settings"    
    @selected_menu = params[:selected_menu] if !params[:selected_menu].blank?
  end
  

  def archive_studio
    if params[:studio] and params[:studio][:studio_id] != ""
        @studios = Studio.find(:all,:conditions=>["id=?",params[:studio][:studio_id]])
        @current_selected = params[:studio][:studio_id]
    else
      @studios = Studio.find(:all,:conditions=>["name like ? ","(archive)%"],:order=>"name")
      @current_selected=0
    end
  end

  def countrycode
    @country = Country.find(:all)
    render :layout => false
  end
  
  protected

  def authorize_user_for_comment_stream_enabled
    if params[:studio][:comment_stream_enabled] && !current_admin.milyoni_admin?
      head 403
    end
  end
end
