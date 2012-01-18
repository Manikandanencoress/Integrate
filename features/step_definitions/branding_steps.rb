When /^I attach a brand image to the branding form$/ do
  attach_file("Logo", File.expand_path("spec/support/images/image.jpg"))
end