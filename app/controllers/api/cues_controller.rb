class Api::CuesController < ApplicationController
  skip_before_filter :validate_geo_restriction
  before_filter :load_facebook_user, :only => [:share_counter]

  def callback
    if params[:meta] =~ /\[/ #it's a clip'
      video_id = remove_brackets params[:meta]
      @the_clip = Clip.find_by_video_id video_id

      if @the_clip.nil?

        @the_content = brightcove_api video_id
        @the_kind = Clip.create(:video_id => video_id,
                                :movie_id => params[:movie_id],
                                :thumbnail_url => @the_content["thumbnailURL"],
                                :name => @the_content["name"])
      end

    elsif params[:meta] =~ /\~/ # it's a commentary
      video_id = remove_brackets params[:meta]
      @the_commentary = Clip.find_by_video_id video_id

      if @the_commentary.nil?
        @the_content = brightcove_api video_id
        @the_kind = Clip.create(:is_commentary => true,
                                :video_id => video_id,
                                :movie_id => params[:movie_id],
                                :thumbnail_url => @the_content["thumbnailURL"],
                                :name => @the_content["name"])
      end

    elsif params[:meta] =~ /facebook\.com/
      split_it = params[:meta].split(',')
      like_page = split_it.first.gsub("\"", '').gsub(',', '').strip
      the_image = split_it.last.gsub("\"", '').strip
      @the_kind = Like.find_or_create_by_link_and_movie_id(like_page, params[:movie_id])
      @the_kind.update_attributes :name => params[:name], :picture_url => the_image
    else
      #//must be a quote then
      @the_kind = Quote.find_or_create_by_text_and_movie_id params[:meta], params[:movie_id]
    end

    render :json => @the_kind || @the_commentary || @the_clip

  end

  def share_counter
    case params[:kind]
      when 'clip';
        clip = Clip.find params[:id]
        @facebook_user.clips << clip
      when 'like';
        like = Like.find params[:id]
        @facebook_user.likes << like
      when 'quote';
        quote = Quote.find params[:id]
        @facebook_user.quotes << quote
    end

    render :json => {:status => 200}, :status => 200

  end

  private
  def remove_brackets(x)
    x.to_s.gsub(/\W/, '')
  end

  def brightcove_api video_id
    doc = Nokogiri::HTML(open("http://api.brightcove.com/services/library?command=find_video_by_id&token=ZRh043aNSjl-FlXKKw-UZRzKGbvqPgcUHpT3Cmonsztpk0ctofOfZw..&video_id=#{video_id}&video_fields=id,name,thumbnailURL"))
    JSON.parse doc.content
  end


end
