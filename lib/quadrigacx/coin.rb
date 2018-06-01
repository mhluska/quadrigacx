module QuadrigaCX
  module Coin
    BITCOIN = 'bitcoin'.freeze
    BITCOIN_CASH = 'bitcoincash'.freeze
    BITCOIN_GOLD = 'bitcoingold'.freeze
    LITECOIN = 'litecoin'.freeze
    ETHER = 'ether'.freeze

    ALL_COINS = [
      BITCOIN,
      BITCOIN_CASH,
      BITCOIN_GOLD,
      LITECOIN,
      ETHER
    ].freeze

    def self.valid?(type)
      ALL_COINS.include?(type)
    end
  end
end
