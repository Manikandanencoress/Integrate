require 'rack-facebook-method-fix'
Rails.configuration.middleware.insert_before ActionDispatch::Static, Rack::Facebook::MethodFix, :exclude => proc { |env| env['PATH_INFO'].match(/^\/api/) }