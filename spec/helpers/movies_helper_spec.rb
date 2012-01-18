require 'spec_helper'

describe MoviesHelper do

  describe "#movie_splash_link" do
    let(:studio) { Factory :studio }
    let(:movie) { Factory :movie, :title => "A Movie Title", :studio => studio }
    it "creates a image tag for the splash image in a link to FB Oauth redirecting to the app canvas" do
      html = helper.movie_splash_link(movie)

      link_node = Nokogiri::XML(html).css("a")
      link_node.attribute('href').value.should ==
          "https://www.facebook.com/dialog/oauth?client_id=#{studio.facebook_app_id}&redirect_uri=#{movie.facebook_redirect_uri}&scope=user_birthday,publish_stream,email"
      link_node.attribute('target').value.should == "_parent"

      image_node = Nokogiri::XML(html).css('img')
      image_node.attribute('alt').value.should == "A Movie Title"
      image_node.attribute('title').value.should == "A Movie Title"
    end

    it "should grab their birthday information" do
      html = helper.movie_splash_link(movie)
      Nokogiri::XML(html).css('a').attribute('href').value.should =~ /&scope=user_birthday/
    end
  end

  describe "#like_button_for" do
    it "should generate a like button for a movie" do
      movie = Factory(:movie)
      html = helper.like_button_for(movie)
      html.should match("href=\"#{studio_movie_url(movie.studio, movie)}\"")
    end
  end

  describe "#like_box_for" do

    def should_not_show_like_box_for_positions(top, left)
      movie.update_attributes(:like_box_left => left, :like_box_top => top)
      html = helper.like_box_for(movie)

      Nokogiri::XML(html).css('.fanPageLikers like-box').should_not be_present
    end

    let(:movie) { Factory(:movie) }
    it "should show the like box movie has like_box_left and like_box_top set " do
      movie.update_attributes(:like_box_left => 100, :like_box_top => 100)
      html = helper.like_box_for(movie)
      html.should be_html_safe
      Nokogiri::XML(html).css('.fanPageLikers like-box').should be_present
    end
    it "should not show the like box if either of the like box positions aren't set" do
      should_not_show_like_box_for_positions(100, nil)
      should_not_show_like_box_for_positions(nil, 100)
    end
    it "should not show the like box if movie does not have like_box_top or like_box_top set" do
      should_not_show_like_box_for_positions(nil, nil)
    end
  end

  describe "#facebook_metadata_for_movie" do
    it "should render the metadata as safe html" do
      movie = Factory(:movie)
      html = helper.facebook_metadata_for_movie(movie)
      html.html_safe?.should be_true

      elements = Nokogiri::HTML(html)
      elements.css("meta[property='og:title']").attribute('content').value.should == movie.title
      elements.css("meta[property='og:type']").attribute('content').value.should == 'movie'
      elements.css("meta[property='og:url']").attribute('content').value.should == movie.facebook_redirect_uri
      elements.css("meta[property='og:image']").attribute('content').value.should == movie.skin.facebook_dialog_icon.url
      elements.css("meta[property='og:site_name']").attribute('content').value.should == movie.studio.name
      elements.css("meta[property='fb:app_id']").attribute('content').value.should == movie.studio.facebook_app_id
      elements.css("meta[property='og:description']").attribute('content').value.should == movie.facebook_share_text
    end
  end

  describe "#viewing_details_for" do
    let(:studio) { Factory.build :studio, :viewing_details => "abc" }
    let(:movie) { Factory.build :movie, :studio => studio }

    it "delegates to its studio's viewing details and wraps it in html" do
      helper.viewing_details_for(movie).should == "<p>abc</p>\n"
    end

    it "runs the template through mustache using the movie's attributes" do
      studio.viewing_details = "abc {{title}} def"
      helper.viewing_details_for(movie).should == "<p>abc #{movie.title} def</p>\n"
    end

    it "runs the mustache results through markdown" do
      studio.viewing_details = "abc **{{title}}** def"
      helper.viewing_details_for(movie).should == "<p>abc <strong>#{movie.title}</strong> def</p>\n"
    end

    it "converts all links to use target _top" do
      studio.viewing_details = "abc [Some Movie](http://google.com) def"
      expected = %{<p>abc <a href="http://google.com" target="_top">Some Movie</a> def</p>\n}
      helper.viewing_details_for(movie).should == expected
    end

    it "should be html safe" do
      studio.viewing_details = "[Link](http://google.com)"
      helper.viewing_details_for(movie).should be_html_safe
    end
  end

  describe "#facebook_coments_for" do
    it "should return an fb:comments tag, with the colorscheme set from the movie" do
      movie = Factory(:movie, :fb_comments_color => 'light')
      html = Nokogiri.parse(helper.facebook_comments_for(movie))
      html.children.first.attribute('data-colorscheme').value.should == 'light'
    end
  end

  describe "#movie_gallery" do

    context "when given a number of movies per page" do
      context "with less than 1 page of movies" do
        let(:movies) do
          movie = Factory(:movie)
          Array.new(14) { movie }
        end
        before do
          @gallery = Nokogiri::HTML(helper.movie_gallery(movies, :pages_of => 15))
        end

        it "should have a single page" do
          @gallery.css('div').size.should == 1
        end

        it "should have 14 list elements in an ol" do
          @gallery.css('div').first.css('ol').first.css('li').size.should == 14
        end
      end

      context "with more than 1 page of movies" do
        let(:movies) do
          movie = Factory(:movie)
          Array.new(16) { movie }
        end

        before do
          @gallery = Nokogiri::HTML(helper.movie_gallery(movies, :pages_of => 15))
        end

        it "should have a 2 pages" do
          @gallery.css('div').size.should == 2
        end

        it "should paginate to the right number per page/ol" do
          @gallery.css('div').first.css('ol').first.css('li').size.should == 15
        end

        it "should have 1 list element in the second page/ol" do
          @gallery.css('div').last.css('ol').first.css('li').size.should == 1
        end
      end

      context "a single movie" do
        let(:movie) { Factory(:movie) }
        let(:movies) { [movie] }

        before do
          gallery = Nokogiri::HTML(helper.movie_gallery(movies, :pages_of => 15))
          @element = gallery.css('div').first.css('ol').first.css('li')
        end

        it "should have an li with a link to the movie" do
          @element.css("a[href='#{movie.facebook_redirect_uri}'][target='_top']").should be_present
        end

        #it "should have an li with the movie's name" do
        #  @element.css('a').first.text.should include(movie.title)
        #end

        it "should have an image with the movie's skin's poster" do
          @element.css('a').css("img[src='#{movie.skin.gallery_poster.url}']").should be_present
        end
      end
    end

    context "with another number of moves per page" do
      let(:movies) do
        movie = Factory(:movie)
        Array.new(14) { movie }
      end
      it "respects the options" do
        gallery = Nokogiri::HTML(helper.movie_gallery(movies, :pages_of => 4))
        gallery.css('div').size.should == 4
        gallery.css('ol').size.should == 4
      end
    end
  end

end