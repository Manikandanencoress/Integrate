Then /^I should see the studio report:$/ do |expected_table|
  actual_table = table(tableish('table tr', 'td, th'))
  expected_table.diff!(actual_table)
end

When /^I fill in valid studio info$/ do
  studio = Factory :studio, :group_buy_enabled => nil
  attributes = studio.attributes
  keys = attributes.keys - ['id', 'created_at', 'updated_at', 'brightcove_id', 'brightcove_key', 'player', 'Player', 'series_enabled']


  keys.each do |key|
    fill_in key.humanize, :with => attributes[key] unless attributes[key].nil?
  end

  fill_in "Genre list (comma separated)", :with => "Comedy, intense teen drama, Madcap Whodunnits, Propaganda Films"
end

When /^I fill in valid studio info for a Brightcove studio$/ do
  studio = Factory :studio, :group_buy_enabled => nil
  attributes = studio.attributes
  keys = attributes.keys - ['id', 'created_at', 'updated_at', 'player', 'Player', 'series_enabled']


  keys.each do |key|
    fill_in key.humanize, :with => attributes[key] unless attributes[key].nil?
  end

  fill_in "Genre list (comma separated)", :with => "Comedy, intense teen drama, Madcap Whodunnits, Propaganda Films"
end


Then /^I should see an option to activate Paypal$/ do
  page.should have_content("Activate Paypal")
end


Then /^I should see an option to pay with Paypal$/ do
  page.should have_input("paypal")
end

Then /^I should not see an option to pay with Paypal$/ do
  page.should_not have_selector("paypal")
end