module MoviesHelper

  def like_box_for(movie)
    if movie.like_box_left && movie.like_box_top
      html = <<-LIKEBOX
      <div class="fanPageLikers">
        <fb:like-box href="#{movie.facebook_fan_page_url}" width="250" height="180" show_faces="true" border_color="" stream="false" header="false"></fb:like-box>
      </div>
      LIKEBOX
      html.html_safe
    end
  end

  def facebook_metadata_for_movie(movie)
    html = <<ENDMETA
    <meta property="og:title" content="#{movie.title}" />
    <meta property="og:type" content="movie" />
    <meta property="og:url" content="#{movie.facebook_redirect_uri}" />
    <meta property="og:image" content="#{movie.skin.facebook_dialog_icon.url}" />
    <meta property="og:site_name" content="#{movie.studio.name}" />
    <meta property="og:description" content="#{movie.facebook_share_text}" />
    <meta property="fb:app_id" content="#{movie.studio.facebook_app_id}" />
ENDMETA
    html.html_safe
  end

  def tweet_button_for(movie)
    link = link_to 'Tweet',
                   'http://twitter.com/share',
                   'data-text' => movie.twitter_share_text,
                   'data-count' => 'none',
                   'data-url' => movie.facebook_redirect_uri,
                   :class => 'twitter-share-button'
    javascript = javascript_include_tag "http://platform.twitter.com/widgets.js"
    # this is kind of gross, but javascript needs to be loaded after the link
    link + javascript unless request.protocol == "https://"
  end

  def like_button_for(movie)
    url = studio_movie_url(movie.studio, movie)
    fbml = %Q{<fb:like href="#{url}" width="150" caption="#{movie.feed_dialog_caption}" layout="button_count" show_faces="false" send="true" ></fb:like>}.html_safe
    content_tag(:span, fbml, :class => :facebook_like)
  end

  def facebook_comments_for(movie)
    %Q{<fb:comments data-href="#{movie.facebook_redirect_uri}" data-num_posts="2" data-width="675" data-colorscheme="#{movie.fb_comments_color}"></fb:comments>}.html_safe
  end

  def viewing_details_for(movie)
    process_mustache_markdown_template(movie.studio.viewing_details, movie)
  end

  def movie_gallery(movies, option)
    movies.in_groups_of(option[:pages_of], false).map do |page_movies|
      content_tag(:div) do
        list_of_movies(page_movies)
      end
    end.join.html_safe
  end

  def list_of_movies(page_movies)
    content_tag(:ol) do
      render_gallery_movie_items(page_movies)
    end
  end

  private

  def render_gallery_movie_items(movies)
    convert_link_targets_to_top(render :partial => "movies/gallery_movie_item", :collection => movies)
  end

  def convert_link_targets_to_top(html)
    html.gsub(/(href=["'][^"][^']*["'])>/) { %{#{$1} target="_top">} }
  end

  def facebook_oauth_url(movie)
    "https://www.facebook.com/dialog/oauth?client_id=#{movie.studio.facebook_app_id}&redirect_uri=#{movie.facebook_redirect_uri}&scope=user_birthday,publish_stream,email"
  end

end