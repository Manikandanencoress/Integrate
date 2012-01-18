require 'rake'

namespace 'demo' do
  desc "Prepare our db for demoing"
  task 'prepare' => %w(db:schema:load db:seed)

  desc "'Install' Harry Potter 7'"
  task 'install_harry_potter_7' => 'environment' do
    studio = Studio.find_by_name("Warner Bros")
    raise "Please run rake demo:prepare first" unless studio.present?

    movie1 = Movie.create!(:title => "Harry Potter and the Deathly Hallows Part I",
                           :studio => studio,
                           :price => 30,
                           :facebook_fan_page_url => "http://www.google.com",
                           :poster_url => '//sumuru.s3.amazonaws.com/potter-seven-a/video-loader.jpg',
                           :cdn_path => 'rtmpe://facebooktvodfs.fplive.net/facebooktvod/',
                           :purchase_bg_url => '//sumuru.s3.amazonaws.com/potter-seven-a/bg-purchase.jpg',
                           :watch_bg_url => '//sumuru.s3.amazonaws.com/potter-seven-a/bg-watch.jpg',
                           :splash_image_url => '//sumuru.s3.amazonaws.com/potter-seven-a/splash.jpg',
                           :share_fb_link => 'http://www.fb.com',
                           :share_twitter_link => 'http://www.twitter.com',
                           :font_color_help => '#387231',
                           :button_color_gradient_1 => '#59B364',
                           :button_color_gradient_2 => '#2D643D',
                           :popup_bk_color_1 => '#2E5830',
                           :popup_bk_color_2 => '#090B0C',
                           :thumb_popup_image => '//sumuru.s3.amazonaws.com/potter-seven-a/thumb_popup_image.jpg',
                           :logo_popup_image => '//sumuru.s3.amazonaws.com/potter-seven-a/logo_popup_image.png',
                           :action_box_top => '496',
                           :action_box_left=> '19',
                           :video_file_path => 'facebookvod/HP_Year7a_1.2.mp4',
                           :pay_dialog_title => 'Harry Potter and the Deathly Hallows Part I from Warner Bros.',
                           :pay_dialog_image => '//sumuru.s3.amazonaws.com/potter-seven-a/hp7-75x.jpg',
                           :description => 'Watch Harry Potter and the Deathly Hallows Part I from Warner Bros. for only 40 Facebook Credits.',
                           :feed_dialog_image => '//sumuru.s3.amazonaws.com/potter-seven-a/hp7-75x.jpg',
                           :feed_dialog_name => 'Harry Potter and the Deathly Hallows Part I',
                           :feed_dialog_caption => 'Watch now for only 40 credits!',
                           :feed_dialog_desc => "You can watch Harry Potter and the Deathly Hallows Part I right here on Facebook using Facebook Credits - it's only 40 credits. (offer not valid in all states)",
                           :rental_length => 5 * 60)
  end
end

namespace 'player' do
  desc "Prepare our db for type of player for studio"
  task :prepare => :environment do

    studios = Studio.all

    studios.each do |i|
      if i.name.include? "Warner"
        i.update_attribute :player, 'warner'
      else
        i.update_attribute :player, 'brightcove'
      end
    end

    puts "Done!!"
  end
end


namespace 'quotes' do
  desc "Prepare our db for quotes for big lebowski"
  task :prepare => :environment do
    quotes = {559 => %q{Walter: "Donny you're out of your element!"},
              816 => %q{The Dude: "I'm the Dude. So that's what you call me. You know, that or, uh, His Dudeness, or uh, Duder, or El Duderino if you're not into the whole brevity thing."},
              848 => %q{The Dude: "This aggression will not stand, man."},
              1638 => %q{Walter: "Shut the fuck up, Donny."},
              1701 => %q{Donny: "I am the walrus. "},
              1775 => %q{ Jesus: "Nobody fucks with the Jesus. "},
              2363 => %q{Walter: "I'm Shomer Shabbos."},
              2471 => %q{Donny: "Phone's ringin', dude."},
              2966 => %q{The Dude: "Hey, careful, man, there's a beverage here! "},
              3635 => %q{The Stranger: "Sometimes you eat the bear and sometimes, well, he eats you."},
              4830 => %q{The Dude: "That rug really tied the room together. "},
              6672 => %q{The Dude: "The Dude abides. "}
    }

    quotes.each do |quote|
      Quote.create(:movie_id => 44, :quoted_at => quote.first, :text => quote.last)
    end
    puts "Done!!"
  end

end
