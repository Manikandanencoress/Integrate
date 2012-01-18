class Admin::FoosController < Devise::SessionsController
  layout "auth"
  skip_before_filter :validate_geo_restriction
end