require 'spec_helper'

describe 'FacebookSignedRequestUtil' do
  context "#encode" do
    it 'should return an encoded string with signature' do
      encoded_string = 'ZF6NsYCdsTnYj9JK-MKP_KlFphHFOFEXAcnNveyPYxM.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTMwNDA5NTE1OCwidXNlciI6eyJjb3VudHJ5IjoidXMiLCJsb2NhbGUiOiJlbl9VUyIsImFnZSI6eyJtaW4iOjIxfX19'
      hash = {"algorithm"=>"HMAC-SHA256", "issued_at"=>1304095158, "user"=>{"country"=>"us", "locale"=>"en_US", "age"=>{"min"=>21}}}
      secret = 'afe875fe56eb84fee0b3a5dd7af63034'
      FacebookSignedRequestUtil.encode(hash, secret).split('.').last.should == encoded_string.split('.').last
      FacebookSignedRequestUtil.encode(hash, secret).split('.').first.should == encoded_string.split('.').first
    end
  end

  context "#decode" do
    it 'should return the decoded hash' do
      encoded_string = 'ZF6NsYCdsTnYj9JK-MKP_KlFphHFOFEXAcnNveyPYxM.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTMwNDA5NTE1OCwidXNlciI6eyJjb3VudHJ5IjoidXMiLCJsb2NhbGUiOiJlbl9VUyIsImFnZSI6eyJtaW4iOjIxfX19'
      hash = {"algorithm"=>"HMAC-SHA256", "issued_at"=>1304095158, "user"=>{"country"=>"us", "locale"=>"en_US", "age"=>{"min"=>21}}}
      FacebookSignedRequestUtil.decode(encoded_string).should == hash
    end
  end
end