When /^I fill in "([^"]*)" with$/ do |field_name, input_text|
  fill_in field_name, :with => input_text
end

Then /^I should see the html$/ do |text|
  page.body.should include(text)
end

Then /^I should see a "([^\"]*)" submit button$/ do |value|
  page.should have_selector("input[type='submit'][value='#{value}']")
end

Then /^I should not see a "([^\"]*)" submit button$/ do |value|
  page.should_not have_selector("input[type='submit'][value='#{value}']")
end
