Rspec.configure do |config|
  config.before(:each) do
    Sumuru::Application.config.whitelisted_facebook_ids = []
  end
end