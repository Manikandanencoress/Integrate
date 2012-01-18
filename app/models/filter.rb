require 'informal'
class Filter
  include Informal::ModelNoInit

  def initialize(params)
    @params = params || {}
  end

  def self.model_name
    @model_name ||=ActiveModel::Name.new(Filter)
  end
end