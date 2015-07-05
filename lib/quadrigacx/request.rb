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
      resp = hmac_request(*args)
      json = JSON.parse(resp) rescue (return fix_json(resp))
      json.kind_of?(Array) ? json.map { |i| to_hashie(i) } : to_hashie(json)
    end

    private

    def fix_json response
      begin
        JSON.parse(response)

      # The `/cancel_order` route returns `"true"` instead of valid JSON.
      rescue JSON::ParserError
        return true  if response.strip == '"true"'
        return false if response.strip == '"false"'
        response[/"(.*)"/, 1] || response
      end
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

    def raise_error hash
      errorClass =
        case hash.error.code
        when 21 then ExceedsAvailableBalance
        when 22 then BelowMinimumOrderValue
        when 23 then AboveMaximumOrderValue
        else Error
        end

      raise errorClass.new(hash.error) if hash.error
      raise errorClass.new(hash.errors.join(',')) if hash.errors
    end

    def to_hashie json
      hash = Hashie::Mash.new(json)
      raise_error(hash) if hash.error
      hash
    end
  end
end
