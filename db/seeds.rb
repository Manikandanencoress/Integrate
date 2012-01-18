if Rails.env.production?
  raise "OH HELL NO, WUT'SUP DAWG. No more seeding production."
end

def open_file_for_movie(movie_dir, file_name)
  File.open(File.join(Rails.root, 'public', 'images', 'movie_images', movie_dir, file_name))
end

def random_gallery_poster
  @gallery_posters ||= (1..20).map do |x|
    open_file_for_movie('gallery_posters', "fakePoster#{x.to_s.rjust(2, '0')}.png")
  end
  @gallery_posters.sample
end

unless Admin.find_by_email("devs@milyoni.net")
  admin = Admin.create!(:email => "devs@milyoni.net", :password => "GetW1th1t", :password_confirmation => "GetW1th1t")
end


def create_studio(name)
  canvas_page = 'http://apps.facebook.com/sumuru_example/'
  facebook_app_id = '217556128271512'
  unless studio = Studio.find_by_name(name)

    viewing_details = <<-DETAILS
                            After purchasing this license, you may watch {{title}}
                            as many times as you wish within a 48 hour period. If you
                            exit Facebook, simply return to the official
                            [{{title}}]({{facebook_fan_page_url}})
                            and select the WATCH tab. Alternatively, you can select
                            {{title}} application that appears on the left side of
                            your Facebook profile page to re-open the video player window.
                            Your license to watch {{title}} is not transferable.
    DETAILS
    viewing_details.gsub!("\n")
    viewing_details.gsub!(/\s+/, " ")

    studio = Studio.create!(:facebook_canvas_page => canvas_page,
                            :facebook_app_id => facebook_app_id,
                            :name => name,
                            :help_text => "If you have any problems with video playback please email <a href='mailto:info@milyoni.com'>info@milyoni.com</a> or call 1-866-936-7857 between 6am - 6pm PST.",
                            :privacy_policy_url => 'http://www.whatever.com/policy',
                            :viewing_details => viewing_details,
                            :max_ips_for_movie => 3,
                            :copyright_notice => "&copy; {{name}} #{Time.now.year}"
    )

    unless studio.valid?
      puts studio.errors.full_messages
      raise "Studio is invalid!"
    end

    wb_logo = File.open(File.join(Rails.root, 'public', 'images', 'studio_images', 'WBlogo.png'))
    studio.branding.update_attributes! :logo => wb_logo
    
    #studio genre list
    studio.genre_list = %w[Action Adventure Animation Biography Children Comedy Crime Documentary Drama Family Fantasy
    History Horror Music Musical Mystery Romance Sci-Fi Sports Thriller War Western ].join(", ")
    studio.save!
  end

  studio
end

def create_movies_for(studio)
  puts "Creating movies for #{studio.name}"

  unless the_matrix = studio.movies.find_by_title("Seed The Matrix") && the_notebook = studio.movies.find_by_title("Seed The Notebook")
    the_matrix = Movie.new(:title => "Seed The Matrix",
                           :studio => studio,
                           :price => 30,
                           :facebook_fan_page_url => "http://www.facebook.com/TheMatrixMovie",
                           :font_color_help => '#387231',
                           :button_color_gradient_1 => '#59B364',
                           :button_color_gradient_2 => '#2D643D',
                           :popup_bk_color_1 => '#2E5830',
                           :popup_bk_color_2 => '#090B0C',
                           :action_box_top => '495',
                           :action_box_left => '19',
                           :like_box_top => 495,
                           :like_box_left => 380,
                           :pay_dialog_title => 'The Matrix from Warner Bros.',
                           :description => 'Watch The Matrix from Warner Bros. for only 40 Facebook Credits.',
                           :feed_dialog_name => 'The Matrix',
                           :feed_dialog_link => "http://www.google.com",
                           :feed_dialog_caption => 'Watch now for only 40 credits!',
                           :facebook_share_text => "You can watch {{title}} right here on Facebook using Facebook Credits - it's only {{price}} credits. (offer not valid in all states)",
                           :released => true,
                           :rental_length => 5 * 60)

    if the_matrix.studio.is_warner?
      the_matrix.cdn_path = 'rtmpe://facebooktvodfs.fplive.net/facebooktvod/'
      the_matrix.video_file_path = 'facebookvod/MatrixThe_FB_1.2.mp4'
    else
      the_matrix.brightcove_movie_id = "1031069428001"
    end

    the_matrix.save!
    the_matrix.skin.update_attributes! :splash_image => open_file_for_movie('matrix', 'splash.jpg'),
                                       :watch_background => open_file_for_movie('matrix', 'bg-watch.jpg'),
                                       :purchase_background => open_file_for_movie('matrix', 'bg-purchase.jpg'),
                                       :tax_popup_logo => open_file_for_movie('matrix', 'logo-modal.png'),
                                       :tax_popup_icon => open_file_for_movie('matrix', 'gfx-modal.jpg'),
                                       :player_background => open_file_for_movie('matrix', 'video-loader.jpg'),
                                       :facebook_dialog_icon => open_file_for_movie('matrix', '75x.jpg'),
                                       :gallery_poster => open_file_for_movie('matrix', 'gallery-poster.png')

    #create genre
    the_matrix.update_attributes(:genre_list => %w[Action Adventure Animation Biography Children Comedy Crime Documentary Drama Family Fantasy
    History Horror Music Musical Mystery Romance Sci-Fi Sports Thriller War Western ].reverse.join(", "))
    the_matrix.reload.genres
    the_matrix.update_attributes(:genre_list => "Sci-Fi")

    the_notebook = Movie.new(:title => "Seed The Notebook",
                                 :studio => studio,
                                 :price => 40,
                                 :facebook_fan_page_url => "http://www.facebook.com/TheNotebookMovie",
                                 :font_color_help => '#A69F8C',
                                 :button_color_gradient_1 => '#F36F79',
                                 :button_color_gradient_2 => '#8F0606',
                                 :popup_bk_color_1 => '#B5AEA4',
                                 :popup_bk_color_2 => '#706B60',
                                 :action_box_top => '490',
                                 :action_box_left => '68',
                                 :like_box_top => 495,
                                 :like_box_left => 380,
                                 :pay_dialog_title => 'The Notebook from Warner Bros.',
                                 :description => 'Watch The Notebook from Warner Bros. for only 30 Facebook Credits.',
                                 :feed_dialog_name => 'The Notebook',
                                 :feed_dialog_link => "http://www.google.com",
                                 :feed_dialog_caption => 'Watch now for only 30 credits!',
                                 :facebook_share_text => "You can watch {{title}} right here on Facebook using Facebook Credits - it's only {{price}} credits. (offer not valid in all states)",
                                 :released => true,
                                 :rental_length => 5 * 60)


    if the_notebook.studio.is_warner?
      the_notebook.cdn_path = 'rtmpe://facebooktvodfs.fplive.net/facebooktvod/'
      the_notebook.video_file_path = 'facebookvod/NotebookThe_FB_1.2.mp4'
    else
      the_notebook.brightcove_movie_id = "1031069428001"
    end
    the_notebook.save!

    the_notebook.skin.update_attributes! :splash_image => open_file_for_movie('notebook', 'splash.jpg'),
                                         :watch_background => open_file_for_movie('notebook', 'bg-watch.jpg'),
                                         :purchase_background => open_file_for_movie('notebook', 'bg-purchase.jpg'),
                                         :tax_popup_logo => open_file_for_movie('notebook', 'logo-modal.png'),
                                         :tax_popup_icon => open_file_for_movie('notebook', 'gfx-modal.jpg'),
                                         :player_background => open_file_for_movie('notebook', 'video-loader.jpg'),
                                         :facebook_dialog_icon => open_file_for_movie('notebook', '75x.jpg'),
                                         :gallery_poster => open_file_for_movie('notebook', 'gallery-poster.png')


  end

  # make lots of copies of the movies to populate the gallery
  if (studio.movies.count < 40)
    40.times do
      new_movie = the_matrix.clone
      new_movie.title = Faker::Company.catch_phrase
      new_movie.skin = the_matrix.skin.clone
      new_movie.save
      new_movie.skin.gallery_poster = random_gallery_poster
      new_movie.skin.save
    end
  end

end

warner = create_studio "Warner Bros"
create_movies_for warner

brightcove_studio = create_studio "A BrightCove Studio"
brightcove_studio.brightcove_id = '938558697001'
brightcove_studio.brightcove_key = 'AQ~~,AAAA2jbW_lE~,iqhqlbZiY1VT_DRmFnNib3zDXUzvvIW4'
brightcove_studio.save!

create_movies_for brightcove_studio