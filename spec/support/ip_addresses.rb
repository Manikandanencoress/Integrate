Rspec.configure do |config|
  config.after(:each, :type => :controller) do
    @request.env['REMOTE_ADDR'] = '0.0.0.0'
  end
end