class KeyGenerator
  require "digest/sha1"
  def self.generate(length = 128)
    Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..length]
  end
end