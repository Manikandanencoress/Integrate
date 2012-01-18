Rails.configuration.middleware.insert_before ActionDispatch::Static, Rack::SSL, :exclude => proc { |env| !env['PATH_INFO'].match(/^\/admin/) }
