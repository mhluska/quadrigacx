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
    def initialize(options = {})
      raise ArgumentError.new('Options hash required') unless options.is_a?(Hash)

      @client_id  = options[:client_id]
      @api_key    = options[:api_key]
      @api_secret = options[:api_secret]
    end
  end
end
