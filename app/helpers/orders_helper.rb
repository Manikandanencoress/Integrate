module OrdersHelper
  def show_video_player_for(movie)
    if movie.studio.is_warner?
      render :partial => 'shared/warner_player', :locals => {:movie => movie}
    elsif movie.studio.is_milyoni?
      render :partial => 'shared/milyoni_player', :locals => {:movie => movie}
    else
      render :partial => 'shared/brightcove_player', :locals => {:movie => movie}
    end
  end


end