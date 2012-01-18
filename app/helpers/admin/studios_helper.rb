module Admin::StudiosHelper
  def total_visitors(studio,flag)
    limit_str= "limit 3"
    limit_str= "" if flag 
    sql = "select movies.id as movie_id,count(page_visits.id) as total_visitors from movies,page_visits where movies.studio_id=#{studio.id} and  movies.id=page_visits.movie_id group by movies.id,movies.title order by total_visitors desc #{limit_str}"
    movies = Movie.find_by_sql(sql)
    if movies.length > 0
      return movies
    else
      sql = "select movies.id as movie_id from movies,studios where movies.studio_id=studios.id and movies.studio_id=#{studio.id}"
      movies = Movie.find_by_sql(sql)
    return movies
    end
  end
  
  def friend_count(user)
     pagevisit = PageVisit.find(:first,:conditions=>["user_id = ?",user.id])
     return 0 if pagevisit == nil
     movie = Movie.find(pagevisit.movie_id)
     if movie.studio != nil  
     begin
     fb_auth = FbGraph::Auth.new(movie.studio.facebook_app_id,movie.studio.facebook_app_secret)
     token = fb_auth.client.access_token! 
     facebook_user = FbGraph::User.fetch(user.facebook_user_id, :access_token => token)
     friends = facebook_user.fetch.friends
     return friends.size
     rescue
     return "-"
     end
     else
     return 0
     end
   end
end
