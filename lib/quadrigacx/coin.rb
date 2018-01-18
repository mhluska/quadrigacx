module QuadrigaCX
  module Coin
    BITCOIN = 'bitcoin'
    BITCOIN_CASH = 'bitcoincash'
    BITCOIN_GOLD = 'bitcoingold'
    LITECOIN = 'litecoin'
    ETHER = 'ether'

    def self.valid? type
      ALL_COINS.include?(type)
    end

    private

    ALL_COINS = [
      BITCOIN,
      BITCOIN_CASH,
      BITCOIN_GOLD,
      LITECOIN,
      ETHER
    ]
  end
end
