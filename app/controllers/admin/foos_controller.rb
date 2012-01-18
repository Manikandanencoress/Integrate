class Admin::FoosController < Devise::SessionsController
  skip_before_filter :validate_geo_restriction
end