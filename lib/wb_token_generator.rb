require 'openssl'

module WbTokenGenerator
  class TokenGenerator
    public
      def self.generate(server, asset)
        begin
          server += (!(server.to_s.end_with?("/"))) ? "/" : ""                              # Add "/" to end of server string
          asset   = (asset.to_s.start_with?("/"))   ? asset.to_s.slice(/\w.*/) : asset      # Remove leading "/" in asset
          gen     = "0"                                                                     # Secret key generation number (0-9)
          key     = "rXt9\+UPEcqjFBrRaQNn\=dAVqMnP6mETVRgKFPT8TckuVRD\@yt\$x+MGH\-gJuVT4g"  # Secret key
          uri     = "/facebooktvodsec/" + asset.to_s
          ct      = Time.new.getgm                                                          # Current Time
          exp     = 60                                                                      # Expiration Window (in seconds)
          uri    += "#{uri.index('?').nil? ? "?" : "&"}stime=#{ct.to_i }&etime=#{(ct + exp).to_i }" # Add expiration window
          hash    = compute_hash(gen, key, uri)                                             # Compute the hash code

          # Create final url
          final_uri= asset.to_s.slice(/(\.mp4|\.f4v)/).to_s.slice(/\w+/).to_s
          final_uri= (final_uri.length > 0) ? final_uri + ":" + asset.to_s.gsub(/(\.mp4|\.f4v)/, "") : asset.to_s
          "#{server.strip}#{final_uri.strip}#{(server.to_s + final_uri.to_s).index('?').nil? ? "?" : "&"}stime=#{ct.to_i}&etime=#{(ct + exp).to_i}&token=#{hash}"
        rescue Exception => e
          puts      "Error generating token. #{e}\n"
        end
      end

      # compute_hash - compute the hash authenticator to append to a URI
      #
      # Parameters:
      # IN gen: A number 0-9 identifying the key generation number
      # IN key: A character string key between 20 and 64 bytes long
      # IN uri: The URI, less the hash code, to be authenticated
      #
      # Returns the hash string value if successful, otherwise returns undef
      # and an error string via rerr
      def self.compute_hash(gen, key, uri)
        # Most of this error checking would not be necessary in a production
        # environment - it is provided for illustration of usage only.

        rerr  = "ERROR: Invalid GEN value"
        raise ArgumentError, rerr unless !gen[/^\d$/].nil?

        rerr  = "ERROR: Invalid key length"
        raise ArgumentError, rerr unless key.to_s.length >= 20 && key.to_s.length <= 64

        rerr  = "ERROR: No URI provided"
        raise ArgumentError, rerr unless !uri.nil?

        # compute the hash and check to be sure it worked
        digest= OpenSSL::Digest::Digest.new('SHA1')
        hmac  = OpenSSL::HMAC.hexdigest(digest, key, uri)

        rerr  = "ERROR: Failed to compute hash!"
        raise Exception, rerr unless defined?(hmac)

        sprintf "%1.1s%20.20s", gen, hmac
      end
    end
end

if (__FILE__ == $0)
  if (ARGV.length == 2)
    print WbTokenGenerator::TokenGenerator.generate(ARGV[0], ARGV[1]) + "\n"
  else
    print "Error: You need to pass 2 arguments, the first is the server path, the second is the asset path.\n"
  end

end
