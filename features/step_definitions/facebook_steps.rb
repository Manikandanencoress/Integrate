Then /^I should see a facebook popup "([^"]*)"$/ do |text|
  page.redirect_to "www.facebook.com/api/test"
  assert page.has_content?(text)
end

Then /^the facebook popup should have a "([^"]*)" link$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I press continue on the facebook popup$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^a facebook stream with a "([^"]*)" link$/ do  |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the facebook popup should not have a "([^"]*)" link$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

And /^I should see a facebook popup "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

And /^the facebook popup should have a "([^"]*)" link$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end