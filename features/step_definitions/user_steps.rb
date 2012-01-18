When /^"([^\"]*)" from (\w{2}) has used the site$/ do |fb_user_name,  country_code|
  Factory(:user, :name => fb_user_name, :country => country_code)
end

Then /^I should see the users table:$/ do |expected_table|
  actual_table = table(tableish('table tr', '.name, .country, .orders, .visits'))
  expected_table.diff!(actual_table)
end

When /^I filter to only show purchasers$/ do
  check "Show only purchasers"
  click_button "Filter"
end

When /^"([^\"]*)" has looked at "([^\"]*)" (\d+) times?$/ do |user, title, visits|
  user = User.find_by_name(user)
  movie = Movie.find_by_title!(title)
  visits.to_i.times { movie.page_visits.for_purchase_page.create! :user => user}
end

Given /^I'm logged into Facebook as "([^\"]*)"$/ do |name|
  @current_user = Factory(:user, :name => name)
  User.stub!(:find_or_create_from_fb_graph).and_return(@current_user)
end

Given /^"([^"]*)" has an active order for "([^"]*)"$/ do |fb_user_name, title|
  current_user = User.find_by_name!(fb_user_name)
  movie = Movie.find_by_title!(title)
  order = Factory(:order, :user => current_user, :movie => movie).settle!
end

Given /^a facebook user "([^\"]*)"$/ do |username|
  Factory(:user, :name => username)
end