class Paypal < ActiveRecord::Base

  belongs_to :order

  P_ENV = 'live'

  class << self

    def params_for_credentials(studio_id = nil)
      if P_ENV != 'live'
        {:user => 'milyon_1311965754_biz_api1.gmail.com',
         :pw => '1311965791',
         :signature => 'AtJUhScRg337JCs0p4ybDzvSCVcfA.6wmw2rLHbBZ6jvJdq.DaZWJMWW'}
      else
        the_studio = Studio.find(studio_id)
        if the_studio && !the_studio.paypal_api_password.blank?
          {:user => the_studio.paypal_api_user,
           :pw => the_studio.paypal_api_password,
           :signature => the_studio.paypal_api_signature}
        else #use milyoni default
          {:user => 'paypal_api1.milyoni.com',
           :pw => 'RSHPAYG4MSTTQ96B',
           :signature => 'AK9h7sypmDnh8z21iB9vVet3MZhfAoqYS7.hfKZuy14FJftJA6WJuyil'}
        end

      end
    end

    def incontext_url token
      the_url = P_ENV == 'live' ?
          "https://www.paypal.com/incontext?" :
          "https://www.sandbox.paypal.com/incontext?"
      the_url + token
    end


    def endpoint
      P_ENV == 'live' ?
          "https://api-3t.paypal.com/nvp" :
          "https://api-3t.sandbox.paypal.com/nvp"
    end

    def base_url request, studio_id
      if Rails.env == 'development'
        'https://local.milyoni.net/studios/' + studio_id.to_s
      else
        "#{request.protocol + request.host}/studios/#{studio_id}"
      end
    end

    def gobble_to_hash content
      better = {}
      content.split('&').each do |meat|
        cut = meat.split('=')
        better.merge!({cut[0].to_sym => cut[1]})
      end
      better
    end


    def setup_user_endpoint(studio_id)
      credents = params_for_credentials(studio_id)
      endpoint +
          "?USER=#{credents[:user]}" +
          "&PWD=#{credents[:pw]}" +
          "&SIGNATURE=#{credents[:signature]}"
    end


    def params_for_product request, movie, user_id, tax = 0, coupon_price = nil

     the_price = coupon_price || movie.price

      paypal_price = Paypal.format_for(the_price)

     puts "****** paypal_price ********"
     puts paypal_price
     puts "****** coupon.try(:price) ********"
     puts coupon_price
     
     
      "&CANCELURL=#{base_url(request, movie.studio_id )}/movies/#{movie.id}/paypal_cancel" +
          "&PAYMENTREQUEST_0_DESC=#{movie.encoded_title}" +

          # the grand total amount
          "&PAYMENTREQUEST_0_AMT=#{paypal_price}" +

          # the sub total amount
          "&PAYMENTREQUEST_0_ITEMAMT=#{paypal_price}" +

          # the item amount
          "&L_PAYMENTREQUEST_0_AMT0=#{paypal_price}" +
          "&L_PAYMENTREQUEST_0_NAME0=#{movie.encoded_title}" +
          "&L_PAYMENTREQUEST_0_NUMBER0=#{movie.id}" +
          "&USER_ID=#{user_id}" +
          "&PAYMENTREQUEST_0_TAXAMT=#{tax}" +
          "&L_PAYMENTREQUEST_0_TAXAMT0=#{tax}" +

          "&VERSION=78" +
          "&PAYMENTREQUEST_0_CURRENCYCODE=USD" +
          "&PAYMENTREQUEST_0_PAYMENTACTION=Sale" +
          "&L_PAYMENTREQUEST_0_ITEMCATEGORY0=Digital" +
          "&L_PAYMENTREQUEST_0_QTY0=1"
    end

    def movie_info(token, studio_id)
      content = Paypal.ec_details_from(token, studio_id)
      puts "******** CONTENTS FROM ORDER_INFO ***"
      puts content

      Paypal.get_content content
    end

    def get_content(content)
      things = {}

      content.split('&').each do |i|
        if i.match('L_PAYMENTREQUEST_0_NUMBER0')
          things[:movie_id] = i.gsub(/L_PAYMENTREQUEST_0_NUMBER0=/, '')
        end

        if i.match('USER_ID')
          things[:user_id] = i.gsub(/USER_ID=/, '')
        end

      end
      things
    end

    def ec_details_from token, studio_id = nil
      paypal_endpoint = setup_user_endpoint(studio_id) +
          "&VERSION=78&METHOD=GetExpressCheckoutDetails&TOKEN=#{URI.decode(token)}"

      doc = Nokogiri::HTML(open(paypal_endpoint))

      puts "********* CONTENT *********"
      puts doc.content
      doc.content
    end

    def tokenize token
      token.sub(/\%2d/, '-')
    end


    def initial_token_for request, movie, user_id, tax = 0, coupon_price = nil
      #lets build out the URL
      paypal_endpoint = setup_user_endpoint(movie.studio_id) +
          "&RETURNURL=#{base_url(request, movie.studio_id)}/movies/#{movie.id}/paypal_return?user_id=#{user_id}" +
          "&METHOD=SetExpressCheckout" +
          params_for_product(request, movie, user_id, tax, coupon_price)


      doc = Nokogiri::HTML(open(paypal_endpoint))

      the_token = doc.content.sub(/\%2d/, '-').to_s[0, 26].sub('TOKEN', 'token')
      puts "********* ENDPOINT ***********"

      puts paypal_endpoint

      puts "****************************"
      puts the_token

      the_token.match('token') ? the_token : false
    end

    def charge_transaction request, token, payer_id, order, user_id

      paypal_endpoint = setup_user_endpoint(order.movie.studio.id) +
          "&METHOD=DoExpressCheckoutPayment" +
          "&RETURNURL=#{base_url request, order.movie.studio.id}/movies/#{order.movie_id}?show_facebook_feed_dialog=true" +
          "&TOKEN=#{token}" +
          "&PAYERID=#{payer_id}" +

          params_for_product(request, order.movie, order.id, user_id)

      puts "********** END POINT ***********"

      puts paypal_endpoint

      doc = Nokogiri::HTML(open(paypal_endpoint))

      puts "********* FINAL CONTENT  ************"
      puts doc.content

      if doc.content.match('ACK=Success')
        order.settle!
        content = Paypal.gobble_to_hash doc.content
        created = create :correlationid => content[:CORRELATIONID],
                         :token => Paypal.tokenize(content[:TOKEN]),
                         :payerid => payer_id,
                         :order_id => order.id,
                         :status => content[:PAYMENTINFO_0_PAYMENTSTATUS]

        puts "****** PAYPAL CAPTURED! *********** "
        puts created.id

      else
        order.update_attribute(:status, 'rejected paypal')
        false
      end

    end

  end

  def settle(payerid)
    update_attributes! :status => 'settled',
                       :payerid => payerid
  end


  def self.format_for(price)
    (price.to_f * 0.1).to_i
  end

  def self.details(token)
    xml = Builder::XmlMarkup.new :indent => 2
    xml.tag! 'GetExpressCheckoutDetailsReq' do
      xml.tag! 'GetExpressCheckoutDetailsRequest' do
        xml.tag! 'Token', token
      end
    end

    xml.target!
  end


end
