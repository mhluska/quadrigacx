module QuadrigaCX
  autoload :Public,  'quadrigacx/client/public'
  autoload :Private, 'quadrigacx/client/private'

  class Client
    include Request
    include Public
    include Private

    attr_reader :api_key, :api_secret, :client_id

    # Initialize a LocalBitcoins::Client instance
    #
    # options[:api_key]
    # options[:api_secret]
    #
    def initialize options = {}
      unless options.is_a?(Hash)
        raise ArgumentError, 'Options hash required'
      end

      @client_id  = options[:client_id]
      @api_key    = options[:api_key]
      @api_secret = options[:api_secret]
    end
  end
end
