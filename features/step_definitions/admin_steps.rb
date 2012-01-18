def login_as(admin)
  visit new_admin_session_url(:protocol => "https://")
  fill_in "Email", :with => admin.email
  fill_in "Password", :with => admin.password
  click_button "Sign in"
end

Given /^I am logged in as a milyoni admin$/ do
  admin = Factory(:admin)
  login_as(admin)
end

Given /^I am logged in as a "([^"]*)" admin$/ do |studio_name|
  studio = Studio.find_by_name(studio_name)
  raise "Can't find your studio" unless studio.present?
  admin = Factory(:admin, :studio => studio)
  login_as admin
end

Given /^there is an invitation to "([^\"]*)"$/ do |email|
  Factory(:invitation, :email => email)
end

Given /^there is a studio invitation to "([^\"]*)" for "([^\"]*)"$/ do |email, studio_name|
  studio = Studio.find_by_name(studio_name)
  Factory(:invitation, :email => email, :studio => studio)
end

When /^I should see the invitation to "([^\"]*)"$/ do |email|
  within "ul.invitations" do
    page.should have_content(email)
  end
end

When /^I invite "([^\"]*)"$/ do |email|
  fill_in "Email", :with => email
  click_button "Send"
end

Then /^"([^"]*)" should be a "([^"]*)" admin$/ do |email, studio_name|
  admin = Admin.find_by_email(email)
  admin.should be_studio_admin
  admin.studio.should == Studio.find_by_name(studio_name)
end

When /^I enter my admin login info as "([^"]*)"$/ do |login_info|
  user_name, password = login_info.split("/")
  fill_in 'admin_email', :with => user_name
  fill_in 'admin_password', :with => password
  fill_in 'admin_password_confirmation', :with => password
end
