module FacebookAuthenticationFaker
  def self.authed_facebook_signed_request(params = {})
    params['algorithm'] ||= "HMAC-SHA256"
    params['oauth_token'] ||= "217556128271512|2.Yw2eceI24HLevhDE4FaSkA__.3600.1304100000.1-100002312958755|AZkP7f2Ed8g1tnteeiR2On5gdrw"
    params['expires'] ||= 0 # Don't ever expire
    FacebookSignedRequestUtil.encode(params, "idontcare")
  end
end