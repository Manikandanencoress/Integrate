When /^choose all the images to upload$/ do
  path = "./features/fixtures/images/image.jpg"
  [
      :watch_background,
      :purchase_background,
      :splash_image,
      :tax_popup_logo,
      :tax_popup_icon,
      :player_background,
      :facebook_dialog_icon
  ].each do |attachment|
    attach_file(attachment.to_s, File.expand_path(path))
  end
end

Then /^I should see all of the image previews$/ do
  page.should have_selector("img[src*='image.jpg']")
end
