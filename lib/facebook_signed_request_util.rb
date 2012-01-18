require 'json'
require 'base64'
require 'openssl'

class FacebookSignedRequestUtil
  def self.encode(params, secret)
    encoded_param = Base64.encode64(JSON.generate(params)).gsub("\n", '')
    signature = OpenSSL::HMAC.digest('sha256', secret, encoded_param)
    encoded_signature = Base64.encode64(signature).gsub("=", '')
    "#{encoded_signature}.#{encoded_param}".gsub("\n", '').gsub('+', '-').gsub('/', '_')
  end

  def self.decode(encoded_string)
    encoded_data = encoded_string.split('.').last
    JSON.parse(Base64.decode64(encoded_data))
  end
end

# 
# encoded_signature, encoded_data = signed_request.split('.')
# signature = base64_url_decode(encoded_signature)
# expected_signature = OpenSSL::HMAC.digest('sha256', settings.secret, encoded_data)
# if signature == expected_signature
#   JSON.parse base64_url_decode(encoded_data)