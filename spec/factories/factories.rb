Factory.sequence :title do
  Faker::Lorem.words(3).join(' ')
end

Factory.define :coupon do |m|
  m.title "My Special!"
  m.code { Faker::Lorem.words(3).to_sentence }
  m.percent "25"
  m.association(:movie)
end

Factory.define :quote do |m|
  m.text "Holy Cow!"
  m.quoted_at Time.now
  m.association(:movie)
end

Factory.define :clip do |m|
  m.name { Faker::Lorem.words(5).to_sentence}
  m.association(:movie)

end


Factory.define :movie do |m|
  m.title { Factory.next(:title) }
  m.price 30
  m.font_color_help '#387231'
  m.button_color_gradient_1 "#FFF"
  m.button_color_gradient_2 "#000"
  m.popup_bk_color_1 "#FFF"
  m.popup_bk_color_2 "#000"
  m.association(:studio)
  m.rental_length 100
  m.cdn_path "a_cdn/path"
  m.action_box_top '496'
  m.action_box_left '19'
  m.like_box_top 496
  m.like_box_left 250
  m.video_file_path "a_movie/path"
  m.feed_dialog_name "I'm watchin something!'"
  m.feed_dialog_link "http://apps.fb.com/blah"
  m.feed_dialog_caption "Something you'll like for sure!'"
  m.released true
  m.brightcove_movie_id '993114464001'
  m.age_restricted false
  m.after_create do |movie|
    movie.skin= Factory(:skin)
    movie.save
  end
end


Factory.define :warner_movie, :parent => :movie do |m|
  m.association(:studio) { Factory(:warner_studio) }
  m.cdn_path "a_cdn/path"
  m.video_file_path "a_movie/path"
end

Factory.define :studio do |s|
  s.name { Faker::Company.name }
  s.facebook_canvas_page "http://example.com/my_cool_app/"
  s.facebook_app_id "1234567890"
  s.facebook_app_secret "idontcare"
  s.help_text "If you need help, email sos@milyoni.net and wait 10 to 14 days."
  s.privacy_policy_url "http://wb.com/privacy"
  s.viewing_details { Faker::Lorem.sentence(5) }
  s.player 'milyoni'
  s.max_ips_for_movie 3
  s.genre_list "Comedy, Sci-Fi"
  s.group_buy_enabled false
end

Factory.define :redeem_discount do |d|
  d.association(:order)
  d.association(:group_discount)
end

Factory.define :warner_studio, :parent => :studio do |s|
  s.name "Warner Bros."
end

Factory.define :brightcove_studio, :parent => :studio do |s|
  s.brightcove_id "993020440001"
  s.brightcove_key "AQ~~,AAAA5zSlYXk~,KAZR-IVH77v-wHC6WxtQYB1D1Me4pgHX"
end

Factory.define :order do |o|
  o.association(:movie)
  o.association(:user)
end

Factory.define :group_discount do |o|
  o.association(:order)
  o.discount_key KeyGenerator.generate
end

Factory.define :admin do |admin|
  admin.email { Faker::Internet.email }
  admin.password { "#{Faker::Internet.user_name}password" }
  admin.configuration_only true
  admin.reporting_only true
end

Factory.define :studio_admin, :parent => :admin do |admin|
  admin.association :studio
end

Factory.define :settled_order, :parent => :order do |o|
  o.status "settled"
  o.rented_at { Time.now }
end

Factory.define :invitation do |invite|
  invite.email { Faker::Internet.email }
end

Factory.define :skin do |skin|
  include ActionDispatch::TestProcess
  Skin.attachment_definitions.keys.each do |attachment|
    skin.send(attachment, fixture_file_upload(Rails.root + 'spec/support/images/image.jpg', 'image/png'))
  end
end

Factory.define :user do |fb_user|
  fb_user.name { Faker::Name.name }
  fb_user.facebook_user_id { Faker::Internet.user_name }
end

Factory.define :watch_visit, :class => PageVisit do |visit|
  visit.association :movie
  visit.association :user
  visit.page 'watch'
end

Factory.define :purchase_visit, :class => PageVisit do |visit|
  visit.association :movie
  visit.association :user
  visit.page 'purchase'
end

Factory.define :stream do |s|
  s.association(:movie)
  s.url "http://facebook.com"
  s.bitrate "1999"
  s.width "334"
  s.height "343"
end

Factory.define :movie_metrics_report do |s|
  s.association(:movie)
  s.date "2011-12-26"
  s.daily_active_users "2000"
  s.page_views "10000"
  s.page_view_unique "5000"
  s.page_like "1000"
end
