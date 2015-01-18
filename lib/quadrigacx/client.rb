require_relative 'client/public'
require_relative 'client/private'

module QuadrigaCX
  class Client
    include QuadrigaCX::Request
    include QuadrigaCX::Public
    include QuadrigaCX::Private

    attr_reader :api_key, :api_secret

    # Initialize a LocalBitcoins::Client instance
    #
    # options[:api_key]
    # options[:api_secret]
    #
    def initialize options={}
      unless options.kind_of?(Hash)
        raise ArgumentError, "Options hash required"
      end

      @use_hmac   = true
      @api_key    = options[:api_key]
      @api_secret = options[:api_secret]
    end
  end
end
