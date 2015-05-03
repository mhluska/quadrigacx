module QuadrigaCX
  module Private
    # List all account balances
    #
    def balance
      request(:post, '/balance')
    end

    # Places a limit buy order. Returns JSON describing the order
    #
    # amount - amount of major currency
    # price  - price to buy at
    # book   - optional, if not specified, will default to btc_cad
    def limit_buy params={}
      raise ConfigurationError.new('No price specified for limit buy') unless params[:price]
      request(:post, '/buy', params)
    end

    # Places a limit sell order. Returns JSON describing the order
    #
    # amount - amount of major currency
    # price  - price to sell at
    # book   - optional, if not specified, will default to btc_cad
    def limit_sell params={}
      raise ConfigurationError.new('No price specified for limit sell') unless params[:price]
      request(:post, '/sell', params)
    end

    # Places a market order. Returns JSON describing the order
    #
    # amount - amount of minor currency to spend
    # book   - optional, if not specified, will default to btc_cad
    def market_buy params={}
      request(:post, '/buy', params)
    end

    # Cancels an order
    #
    # id – a 64 characters long hexadecimal string taken from the list of orders
    def cancel params={}
      request(:post, '/cancel_order', params)
    end

    # Withdraw bitcoins
    #
    # amount  – The amount to withdraw
    # address – The bitcoin address we will send the amount to
    def withdraw params={}
      request(:post, '/bitcoin_withdrawal', params)
    end

    # Returns a JSON list of open orders
    #
    # book - optional, if not specified, will default to btc_cad
    def open_orders params={}
      request(:post, '/open_orders', params)
    end

    # Returns a bitcoin deposit address for funding your account
    def wallet_address params={}
      request(:post, '/bitcoin_deposit_address', params)
    end

    # Returns a descending list of user transactions
    # offset - optional, skip that many transactions before beginning to return results. Default: 0.
    # limit  - optional, limit result to that many transactions. Default: 100.
    # sort   - optional, sorting by date and time (asc - ascending; desc - descending). Default: desc.
    # book   - optional, if not specified, will default to btc_cad
    def user_transactions params={}
      request(:post, '/user_transactions', params).each { |t| t.id = t.id.to_s }
    end
  end
end
