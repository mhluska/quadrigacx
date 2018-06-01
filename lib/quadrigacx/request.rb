require 'rest-client'
require 'json'
require 'openssl'
require 'date'
require 'uri'
require 'digest'
require 'ostruct'
require 'quadrigacx/error'

module QuadrigaCX
  module Request
    API_URL = 'https://api.quadrigacx.com/v2'.freeze

    protected

    def request(*args)
      response = hmac_request(*args)
      response = begin
                   JSON.parse(response, object_class: OpenStruct)
                 rescue JSON::ParserError
                   return fix_json(response)
                 end

      check_error(response)
    end

    private

    def fix_json(response)
      # The `/cancel_order` route returns `"true"` instead of valid JSON.
      return true  if response.strip == '"true"'
      return false if response.strip == '"false"'
      response[/"(.*)"/, 1] || response
    end

    def hmac_request(http_method, path, body = {})
      payload = {}
      url     = "#{API_URL}#{path}"

      if http_method == :get
        url += '?' + URI.encode_www_form(body)
      else
        client_id  = QuadrigaCX.configuration.client_id
        api_key    = QuadrigaCX.configuration.api_key
        api_secret = QuadrigaCX.configuration.api_secret

        raise 'API key, API secret and client ID required!' unless api_key && api_secret && client_id

        nonce     = DateTime.now.strftime('%Q')
        data      = [nonce + client_id + api_key].join
        digest    = OpenSSL::Digest.new('sha256')
        signature = OpenSSL::HMAC.hexdigest(digest, api_secret, data)

        payload = body.merge(key: api_key,
                             nonce: nonce,
                             signature: signature)
      end

      RestClient::Request.execute(
        url: url,
        method: http_method,
        payload: payload.to_json,
        verify_ssl: false,
        headers: {
          content_type: :json,
          accept: :json
        }
      )
    end

    def check_error(responses)
      [responses].flatten.each do |response|
        next unless response.error

        error_class =
          case response.error.code
          when 21  then ExceedsAvailableBalance
          when 22  then BelowMinimumOrderValue
          when 23  then AboveMaximumOrderValue
          when 106 then NotFound
          else Error
          end

        message  = response.error.code.to_s + ' '
        message += response.error.to_s if response.error
        message += response.errors.join(',') if response.errors

        raise error_class.new(message)
      end

      responses
    end
  end
end
