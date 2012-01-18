class Filter::DateFilter < Filter
  attr_accessor :date

  def initialize(params)
    super
    @date = fetch_date_from_params("date")
  end

  protected

  def fetch_date_from_params(field_name)
    field = field_name.to_s
    if @params["#{field}(1i)"]
      Date.new(@params["#{field}(1i)"].to_i,
                 @params["#{field}(2i)"].to_i,
                 @params["#{field}(3i)"].to_i)
    else
      Date.today
    end
  end
end
