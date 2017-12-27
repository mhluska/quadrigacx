module QuadrigaCX
  module Coin
    BITCOIN = 'bitcoin'
    LITECOIN = 'litecoin'
    ETHER = 'ether'

    def self.valid? type
      ALL_COINS.include?(type)
    end

    private

    ALL_COINS = [
      BITCOIN,
      LITECOIN,
      ETHER
    ]
  end
end