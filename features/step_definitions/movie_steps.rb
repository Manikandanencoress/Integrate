def create_movie_from_studio_with_price(title, studio_name=nil, price=nil)
  options = {}
  options[:title] = title
  if studio_name
    options[:studio] = Studio.find_by_name(studio_name) || Factory(:studio, :name => studio_name)
  end
  options[:price] = price if price
  options[:badge_number] = 48
  options[:badge_text] = "HOURS"
  options[:rental_badge] = true
  Factory(:movie, options)
end

Given /^a studio with a "([^"]*)" player called "([^"]*)"$/ do |player, studio_name|
  studio = Factory :studio, :name => studio_name
  studio.branding.save
  studio.player = player
  studio.facebook_canvas_page = "http://example.com/studios/#{studio.id}/"
  studio.save
end

Given /^a studio called "([^"]*)"$/ do |studio_name|
  studio = Factory :studio, :name => studio_name
  studio.branding.save
  studio.facebook_canvas_page = "http://example.com/studios/#{studio.id}/"
  studio.save
end

Given /^a studio called "([^"]*)" with paypal enabled$/ do |studio_name|
  studio = Factory :studio, :name => studio_name
  studio.branding.save
  studio.facebook_canvas_page = "http://example.com/studios/#{studio.id}/"
  studio.paypal_enabled = true
  studio.save
end

Given /^a studio called "([^"]*)" with paypal turned off$/ do |studio_name|
  studio = Factory :studio, :name => studio_name
  studio.branding.save
  studio.facebook_canvas_page = "http://example.com/studios/#{studio.id}/"
  studio.paypal_enabled = false
  studio.save
end

Given /^a movie called "([^"]*)"$/ do |movie_title|
  create_movie_from_studio_with_price(movie_title)
end

And /^a movie called "([^"]*)" from "([^"]*)"$/ do |movie_title, studio_name|
  create_movie_from_studio_with_price(movie_title, studio_name)
end

Given /^a movie called "([^"]*)" which has a price of zero from "([^"]*)"$/ do |movie_title, studio_name|
  create_movie_from_studio_with_price(movie_title, studio_name, price = 0)
end


Given /^a movie called "([^"]*)" from "([^"]*)" with group discount$/ do |movie_title, studio_name|
  options = {}
  options[:title] = movie_title
  options[:studio] = Factory(:studio, :name => studio_name, :group_buy_enabled => true)
  Factory(:movie, options)
end

Given /^a movie called "([^\"]*)" from "([^\"]*)" with an incomplete skin$/ do |movie_title, studio_name|
  movie = create_movie_from_studio_with_price(movie_title, studio_name)
  skin = movie.skin
  skin.purchase_background = nil
  skin.save
end

Given /^a movie called "([^\"]*)" from "([^\"]*)" with price "([^\"]*)"$/ do |movie_title, studio_name, price|
  create_movie_from_studio_with_price(movie_title, studio_name, price)
end

And /^a movie called "([^"]*)" from "([^"]*)" with the attributes:$/ do |movie_title, studio_name, attributes_table|
  Given %{a movie called "#{movie_title}" from "#{studio_name}"}
  movie = Movie.find_by_title(movie_title)
  movie.update_attributes!(attributes_table.hashes.first)
end

When /^I click on the "([^"]*)" splash image$/ do |movie_title|
  click_link movie_title
end

Then /^I should see the splash page for "([^"]*)"$/ do |movie_title|
  page.should have_selector("a img[title='#{movie_title}']")
end

When /^I've gone to the "([^"]*)" watch page and have accepted the FB app$/ do |movie_title|
  movie = Movie.find_by_title(movie_title)
  raise "No Movie Found" unless movie
  User.stub!(:find_or_create_from_fb_graph).and_return(Factory(:user))
  visit studio_movie_path(movie.studio, movie, :signed_request => FacebookAuthenticationFaker.authed_facebook_signed_request('user_id' => '00001'))
end

When /^I've gone to the "([^"]*)" watch page with a valid discount key and have accepted the FB app$/ do |movie_title|
  movie = Movie.find_by_title(movie_title)
  order = Factory(:order, :movie_id => movie.id)
  group_discount = Factory(:group_discount, :order_id => order.id)
  raise "No Movie Found" unless movie
  User.stub!(:find_or_create_from_fb_graph).and_return(Factory(:user))
  visit studio_movie_path(movie.studio, movie, :signed_request => FacebookAuthenticationFaker.authed_facebook_signed_request('user_id' => '00001'), :discount_key => group_discount.discount_key)
end
When /^I've gone to the "([^"]*)" watch page with an invalid discount key and have accepted the FB app$/ do |movie_title|
  movie = Movie.find_by_title(movie_title)
  order = Factory(:order, :movie_id => movie.id)
  group_discount = Factory(:group_discount, :order_id => order.id)
  raise "No Movie Found" unless movie
  User.stub!(:find_or_create_from_fb_graph).and_return(Factory(:user))
  visit studio_movie_path(movie.studio, movie, :signed_request => FacebookAuthenticationFaker.authed_facebook_signed_request('user_id' => '00001'), :discount_key => 'whatever')
end

When /^I fill in valid movie info for a Warner movie$/ do
  movie = Factory :movie
  attributes = movie.attributes
  keys = attributes.keys - ['id', 'created_at', 'updated_at', 'studio_id', 'facebook_fan_page_url', 'brightcove_movie_id', 'like_box_left', 'like_box_top']

  keys.each do |key|
    field = key.humanize
    case key.to_sym
    when :age_restricted, :released
      check field
    when :fb_comments_color
      select 'light'
    when :genre
      select "Comedy"
    else
      fill_in field, :with => attributes[key] if attributes[key]
    end
  end
end

When /^I fill in valid movie info for a Brightcove movie$/ do
  movie = Factory :movie
  attributes = movie.attributes
  keys = attributes.keys - ['id', 'created_at', 'updated_at', 'studio_id', 'facebook_fan_page_url', 'cdn_path', 'video_file_path', 'like_box_left', 'like_box_top']

  keys.each do |key|
    field = key.humanize
    case key.to_sym
    when :age_restricted, :released
      check field
    when :fb_comments_color
      select 'light'
    when :genre
      select "Comedy"
    else
      fill_in field, :with => attributes[key] if attributes[key]
    end
  end
end

def create_visits_to_page(movie_title, number_of_visits, attributes={})
  movie = Movie.find_by_title(movie_title)
  number_of_visits.to_i.times do
    movie.page_visits.create(attributes)
  end
end

Given /^(\d+) visits today to "([^"]*)"$/ do |number_of_visits, movie_title|
  create_visits_to_page movie_title, number_of_visits, :page => 'purchase', :created_at => Date.today.beginning_of_day + 1 # Make sure it's today inclusively
end

Given /^(\d+) visits today to the "([^"]*)" watch page$/ do |number_of_visits, movie_title|
  create_visits_to_page movie_title, number_of_visits, :page => 'watch', :created_at => Date.today.beginning_of_day + 1 # Make sure it's today inclusively
end

Given /^(\d+) visits (\d+) month(?:|s) ago to "([^"]*)"$/ do |number_of_visits, months, movie_title|
  create_visits_to_page movie_title, number_of_visits, :page => 'purchase', :created_at => noon_months_ago_utc(2)
end

Given /^(\d+) visits (\d+) month(?:|s) ago to the "([^"]*)" watch page$/ do |number_of_visits, months, movie_title|
  months_ago = months.to_i.months.ago.beginning_of_day - 1 # Make sure it's before today some months ago
  create_visits_to_page movie_title, number_of_visits, :page => 'watch', :created_at => months_ago
end

When /^I filter to (\d+) month(?:|s) ago$/ do |number|
  date = noon_months_ago_utc(number)
  select(date.year.to_s, :from => "filter[date(1i)]")
  select(date.strftime("%B"), :from => "filter[date(2i)]")
  select(date.day.to_s, :from => "filter[date(3i)]")
  click_button "Filter"
end

When /^I sleep$/ do
  sleep 1000
end

When /^I should see the admin movie preview$/ do
  page.should have_css("#preview_area .splash_preview img")
  page.should have_css("#preview_area .purchase_preview .header")
  page.should have_css("#preview_area .watch_preview .header")
end

Then /^I should see the "([^\"]*)" logo$/ do |studio|
  studio = Studio.find_by_name(studio) || raise("You ain't got no studio called #{studio}")
  studio.branding.logo_file_name.should be_present
  page.should have_selector("img[src*='image.jpg']")
end

When /^(\d+) movies called "([^\"]*)" from "([^\"]*)"$/ do |number_of_movies, movie_name, studio_name|
  studio = Studio.find_by_name(studio_name) || raise("You ain't got no studio called #{studio}")
  movie = Factory.build(:movie, :title => movie_name, :studio => studio)
  number_of_movies.to_i.times do
    movie.clone.save
  end
end

When /^an? "([^\"]*)" called "([^\"]*)" from "([^\"]*)"$/ do |genre_name, movie_name, studio_name|
  studio = Studio.find_by_name(studio_name) || raise("You ain't got no studio called #{studio}")
  genre_list = studio.genre_list
  genre_list << genre_name
  stringified_genre_list = genre_list.join(", ")
  studio.genre_list = stringified_genre_list
  studio.save!
  studio.reload
  Factory(:movie, :genre_list => genre_name, :title => movie_name, :studio => studio)
end

Then /^I should see a gallery table$/ do
  html = Nokogiri::HTML(page.body)
  html.css("table#gallery").should be_present
  html.css("table#gallery").css("tr").size.should == 3
  html.css("table#gallery").css("tr").first.css("td").size.should == 5
end

When /^I filter genre to "([^\"]*)"$/ do |genre|
  select genre, :from => "Sort by"
  click_button "Filter"
end

Then /^I should see "([^\"]*)" in only the active rentals section$/ do |title|
  Then %{I should see "#{title}" within "#rentals"}
  Then %{I should not see "#{title}" within "#galleryCarousel"}
end

Then /^I should see the comment stream$/ do
  page.should have_selector("#commentStream")
end

But /^I should not see the comment stream$/ do
  page.should_not have_selector("#commentStream")
end

Then /^I should see the facebook comments$/ do
  page.should have_selector("comments")
end

Then /^I should not see the facebook comments$/ do
  page.should_not have_selector("comments")
end