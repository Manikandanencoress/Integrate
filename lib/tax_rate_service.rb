class TaxRateService

  def self.build_request_xml(zip_code)
    buffer = ''
    xml = Builder::XmlMarkup.new(:target=>buffer)
    xml.instruct! :xml, :encoding => "UTF-8"
    xml.DatapakServices do
      xml.Source do
        xml.Username('mi53nna')
        xml.Password('y34dfr2')
      end
      xml.TaxService do
        xml.CompNum('239')
        xml.ProjNum('002')
        xml.ShipToZip(zip_code)
        xml.ShipHandle(sprintf("%.2f", 0.00))
        xml.ItemDetail('true')
        xml.TaxDetail('true')
        xml.TaxItems do
           xml.TaxItem do
              xml.ProductID('FB_VOD01')
              xml.Quantity(1)
              xml.Price(sprintf("%.2f", 1.00))
           end
        end
      end
    end
    buffer

  end

  def self.rate_for(zip_code)
    response = make_request_for_zipcode(zip_code)
    response_xml = Nokogiri::XML(response.body)

    status_code = response_xml.css("Code")
    raise InvalidZipError.new("User entered an invalid zip") if status_code.text.to_i == 201
    calculated_tax = response_xml.css("CalculatedTax")
    return 0 if calculated_tax.text == "0.00"

    sum_of_tax_rates(response_xml)
  end

private

  def self.make_request_for_zipcode(zip_code)
    service_url = Sumuru::Application.config.tax_rate_service_url
    uri = URI.parse(service_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = {'Content-Type' => 'text/xml'}
    post = Net::HTTP::Post.new(uri.path, headers)
    post['content-type'] = "text/xml"
    response = http.request post, TaxRateService.build_request_xml(zip_code)
    response
  end

  def self.sum_of_tax_rates(response_xml)
    tax_rates = response_xml.css("TaxRate")
    rates_as_floats = tax_rates.map { |node| node.text.to_f }
    rates_as_floats.inject(&:+)
  end

end

class TaxRateService::InvalidZipError < ArgumentError; end