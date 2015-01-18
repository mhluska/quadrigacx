require 'quadrigacx/request'
require 'quadrigacx/client'
require 'quadrigacx/version'
require 'quadrigacx/error'

module QuadrigaCX
  @@options = {}

  # Define a global configuration
  #
  # options[:api_key]
  # options[:api_secret]
  #
  def self.configure options={}
    unless options.kind_of?(Hash)
      raise ArgumentError, "Options hash required"
    end

    @@options[:use_hmac]   = true
    @@options[:client_id]  = options[:client_id]
    @@options[:api_key]    = options[:api_key]
    @@options[:api_secret] = options[:api_secret]
    @@options
  end

  # Returns global configuration hash
  #
  def self.configuration
    @@options
  end

  # Resets the global configuration
  #
  def self.reset_configuration
    @@options = {}
  end
end
