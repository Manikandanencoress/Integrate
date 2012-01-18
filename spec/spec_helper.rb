require 'rubygems'
require 'spork'

ENV["RAILS_ENV"] ||= 'test'


Spork.prefork do
  # This block is ran when the spork server is initialized, if you change any config files, restart spork
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require "paperclip/matchers"

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
    config.include Paperclip::Shoulda::Matchers
  end

  # require rubymine test formatter stuff
  rubymine_home = ENV['RUBYMINE_HOME'] ||"/Applications/RubyMine 3.1.1.app"
  $:.unshift(File.expand_path("rb/testing/patch/common", rubymine_home))
  $:.unshift(File.expand_path("rb/testing/patch/bdd", rubymine_home))
end

Spork.each_run do
  #put stuff that you need reloaded on each test run in this block
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
  Dir[Rails.root.join("spec/factories.rb")].each { |f| require f }
#  Factory.factories.clear
#  Factory.find_definitions
end
