require 'spec_helper'

def clean_xml(xml)
  xml.gsub(/[\n\s]+/, '')
end

describe 'TaxRateService' do

  describe ".build_request_xml" do
    it "creates proper xml to for a studio ID and a zipcode" do
      expected_xml = <<-XML
        <?xml version="1.0" encoding="UTF-8"?>
        <DatapakServices>
          <Source>
            <Username>mi53nna</Username>
            <Password>y34dfr2</Password>
          </Source>
          <TaxService>
            <CompNum>239</CompNum>
            <ProjNum>002</ProjNum>
            <ShipToZip>98111</ShipToZip>
            <ShipHandle>0.00</ShipHandle>
            <ItemDetail>true</ItemDetail>
            <TaxDetail>true</TaxDetail>
            <TaxItems>
              <TaxItem>
                <ProductID>FB_VOD01</ProductID>
                <Quantity>1</Quantity>
                <Price>1.00</Price>
              </TaxItem>
            </TaxItems>
          </TaxService>
        </DatapakServices>
      XML

      actual_xml = TaxRateService.build_request_xml('98111')
      clean_xml(actual_xml).should == clean_xml(expected_xml)
    end
  end

  describe ".rate_for" do

    it "makes a request to the right service" do
      stub_request(:post, "https://webservices.datapakservices.com:443/TaxServiceTest").to_return(:body => "")
      TaxRateService.rate_for('19044')
      WebMock.should have_requested(:post, "https://webservices.datapakservices.com/TaxServiceTest").with(
                         :body => TaxRateService.build_request_xml('19044'),
                         :headers => {'Content-Type' => 'text/xml'})
    end

    it "uses an environment variable to set the service url" do
      fake_service_url = 'https://foo.com/service'
      stub_request(:post, fake_service_url)
      Sumuru::Application.stub_chain(:config, :tax_rate_service_url).
          and_return(fake_service_url)
      TaxRateService.rate_for('19044')
      WebMock.should have_requested(:post, fake_service_url)
    end

    context "when the service returns a Code 001 - Action successful " do
      context "for a taxable zip" do
        use_vcr_cassette 'tax info for taxable zip', :record => :new_episodes
        it "returns the rounded sum of all of the tax rates supplied by the service" do
          rate = TaxRateService.rate_for '98111'
          rate.should == 0.095
        end
      end

      context "for a non-taxed zip" do
        use_vcr_cassette 'tax info for non-taxable zip', :record => :new_episodes
        it "returns something" do
          rate = TaxRateService.rate_for("94588")
          rate.should == 0
        end
      end

      context "for a zip code that isn't real" do
        use_vcr_cassette 'tax info for invalid zip', :record => :new_episodes
        it "should raise an error" do
          lambda { TaxRateService.rate_for("0") }.should raise_error TaxRateService::InvalidZipError
        end
      end
    end

    context "when the service returns an empty body" do
      use_vcr_cassette 'empty tax response', :record => :new_episodes
      it "returns nil" do
        TaxRateService.rate_for('abcd').should be_nil
      end
    end
  end
end

