require 'vcr'

VCR.config do |c|
  c.cassette_library_dir     = File.join(Rails.root, 'features', 'fixtures', 'cassette_library')
  c.http_stubbing_library    = :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :new_episodes }
end

VCR.cucumber_tags do |t|
  t.tags '@option_with_paypal_on', :record => :new_episodes
  t.tags '@option_with_paypal_off', :record => :new_episodes
  t.tags '@taxes_for_98111', :record => :new_episodes
  t.tags '@group_discount_initiator', :record => :new_episodes
  t.tags '@group_discount_redeemer', :record => :new_episodes
  t.tags '@the_notebook_facebook_url', :record => :new_episodes
  t.tags '@the_notebook_facebook_url_again', :record => :new_episodes
end
