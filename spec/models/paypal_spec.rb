require 'spec_helper'

describe Paypal do


  describe ".tax_format_for" do
    it "gets the user_id" do
      content = "https://api-3t.sandbox.paypal.com/nvp?USER=milyon_1311965754_biz_api1.gmail.com&PWD=1311965791&SIGNATURE=AtJUhScRg337JCs0p4ybDzvSCVcfA.6wmw2rLHbBZ6jvJdq.DaZWJMWW&RETURNURL=https://sumuru-staging.milyoni.net/studios/2/movies/85/paypal_return&METHOD=SetExpressCheckout&CANCELURL=https://sumuru-staging.milyoni.net/studios/2/movies/85/paypal_cancel&PAYMENTREQUEST_0_DESC=Calvin%20and%20Hobbes:%20The%20Movie&PAYMENTREQUEST_0_AMT=3&PAYMENTREQUEST_0_ITEMAMT=3&L_PAYMENTREQUEST_0_AMT0=3&L_PAYMENTREQUEST_0_NAME0=Calvin%20and%20Hobbes:%20The%20Movie&L_PAYMENTREQUEST_0_NUMBER0=85&PAYMENTREQUEST_0_TAXAMT=0&L_PAYMENTREQUEST_0_TAXAMT0=0&VERSION=78&PAYMENTREQUEST_0_CURRENCYCODE=USD&PAYMENTREQUEST_0_PAYMENTACTION=Sale&L_PAYMENTREQUEST_0_ITEMCATEGORY0=Digital&L_PAYMENTREQUEST_0_QTY0=1&USER_ID=17"
      p = Paypal.get_content(content)
      p[:user_id].should == '17'
    end

  end

end
