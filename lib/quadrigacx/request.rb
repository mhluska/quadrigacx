require 'rest-client'
require 'json'
require 'hashie'
require 'openssl'
require 'date'
require 'uri'
require 'digest'

module QuadrigaCX
  module Request
    API_URL = "https://api.quadrigacx.com/v2"

    protected

    def request *args
      resp = @use_hmac ? self.hmac_request(*args) : self.oauth_request(*args)

      begin
        json = JSON.parse(resp.body)

      # The `/cancel_order` route returns `"true"` instead of valid JSON.
      rescue JSON::ParserError
        match = resp.body.match(/"(.*)"/)
        return match ? match[1] : resp.body
      end

      json.kind_of?(Array) ? json.map { |i| to_hashie(i) } : to_hashie(json)
    end

    def hmac_request http_method, path, body={}
      payload = {}
      url     = "#{API_URL}#{path}"

      if http_method == :get
        url += '?' + URI.encode_www_form(body)
      else
        raise 'API key, API secret and client ID required!' unless @api_key && @api_secret && @client_id

        secret    = Digest::MD5.hexdigest(@api_secret)
        nonce     = DateTime.now.strftime('%Q')
        data      = [nonce + @api_key + @client_id].join
        digest    = OpenSSL::Digest.new('sha256')
        signature = OpenSSL::HMAC.hexdigest(digest, secret, data)

        payload = body.merge({
          key: @api_key,
          nonce: nonce,
          signature: signature,
        })
      end

      RestClient::Request.execute(
        url: url,
        method: http_method,
        payload: payload.to_json,
        verify_ssl: false,
        headers: {
          content_type: :json,
          accept: :json,
        },
      )
    end

    # Perform an OAuth API request. The client must be initialized
    # with a valid OAuth access token to make requests with this method
    #
    # path   - Request path
    # body -   Parameters for requests - GET and POST
    #
    # TODO(maros): Implement this when QuadrigaCX supports it.
    def oauth_request http_method, path, body={}
    end

    private

    def to_hashie json
      hash = Hashie::Mash.new(json)

      raise Error.new(hash.error) if hash.error
      raise Error.new(hash.errors.join(',')) if hash.errors

      hash
    end
  end
end
