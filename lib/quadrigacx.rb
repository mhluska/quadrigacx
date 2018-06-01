module QuadrigaCX
  autoload :Error,   'quadrigacx/error'
  autoload :Request, 'quadrigacx/request'
  autoload :Client,  'quadrigacx/client'
  autoload :Coin,    'quadrigacx/coin'
  autoload :Version, 'quadrigacx/version'

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :client_id, :api_key, :api_secret
  end
end
