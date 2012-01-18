class SupportsController < ApplicationController

    layout "admin"
  before_filter :authenticate_admin!
  skip_before_filter :validate_geo_restriction
  def documentation
  end

  def faqs
  end

  def tutorial
  end

  def contactus
  end
end
