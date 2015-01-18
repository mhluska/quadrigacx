require 'rest-client'
require 'json'
require 'hashie'
require 'openssl'
require 'date'
require 'uri'

module QuadrigaCX
  module Request
    API_URL = "https://api.quadrigacx.com/v2"

    protected

    def request(*args)
      resp = @use_hmac ? self.hmac_request(*args) : self.oauth_request(*args)

      hash = Hashie::Mash.new(JSON.parse(resp.body))
      raise Error.new(hash.error) if hash.error
      raise Error.new(hash.errors.join(',')) if hash.errors
      hash
    end

    def hmac_request(http_method, path, body={})
      raise 'Client ID and secret required!' unless @api_key && @api_secret

      digest    = OpenSSL::Digest.new('sha256')
      nonce     = DateTime.now.strftime('%Q')
      params    = URI.encode_www_form(body)
      data      = [nonce, @api_key, path, params].join
      signature = OpenSSL::HMAC.hexdigest(digest, @api_secret, data)
      url       = "#{API_URL}#{path}"

      headers = {
        'Apiauth-Key' => @api_key,
        'Apiauth-Nonce' => nonce,
        'Apiauth-Signature' => signature,
      }

      # TODO(maros): Get the `RestClient::Request.execute` API to work.
      if http_method == :get
        RestClient.get("#{url}?#{params}", headers)
      else
        RestClient.post(url, params, headers)
      end
    end

    # Perform an OAuth API request. The client must be initialized
    # with a valid OAuth access token to make requests with this method
    #
    # path   - Request path
    # body -   Parameters for requests - GET and POST
    #
    # TODO(maros): Implement this when QuadrigaCX supports it.
    def oauth_request(http_method, path, body={})
    end
  end
end
