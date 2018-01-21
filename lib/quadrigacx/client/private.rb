module QuadrigaCX
  module Private
    # List all account balances.
    #
    def balance
      request(:post, '/balance')
    end

    # Place a limit buy order. Returns JSON describing the order.
    #
    # amount - amount of major currency.
    # price  - price to buy at.
    # book   - optional, if not specified, will default to btc_cad.
    def limit_buy params={}
      raise ConfigurationError.new('No price specified for limit buy') unless params[:price]
      request(:post, '/buy', params)
    end

    # Place a limit sell order. Returns JSON describing the order.
    #
    # amount - amount of major currency.
    # price  - price to sell at.
    # book   - optional, if not specified, will default to btc_cad.
    def limit_sell params={}
      raise ConfigurationError.new('No price specified for limit sell') unless params[:price]
      request(:post, '/sell', params)
    end

    # Place a market order. Returns JSON describing the order.
    #
    # amount - amount of major currency to spend.
    # book   - optional, if not specified, will default to btc_cad.
    def market_buy params={}
      request(:post, '/buy', params)
    end

    # Place a market order. Returns JSON describing the order.
    #
    # amount - amount of major currency to sell.
    # book   - optional, if not specified, will default to btc_cad.
    def market_sell params={}
      request(:post, '/sell', params)
    end

    # Cancel an order.
    #
    # id – a 64 characters long hexadecimal string taken from the list of orders.
    def cancel_order params={}
      request(:post, '/cancel_order', params)
    end

    # Return a JSON list of open orders.
    #
    # book - optional, if not specified, will default to btc_cad.
    def open_orders params={}
      request(:post, '/open_orders', params)
    end

    # Returns JSON list of details about 1 or more orders.
    #
    # id – a single or array of 64 characters long hexadecimal string taken from the list of orders.
    def lookup_order params={}
      request(:post, '/lookup_order', params)
    end

    # Withdrawal of the specified coin type.
    #
    # coin    – The coin type
    # amount  – The amount to withdraw.
    # address – The coin type's address we will send the amount to.
    def withdraw coin, params={}
      raise ConfigurationError.new('No coin type specified') unless coin
      raise ConfigurationError.new('Invalid coin type specified') unless Coin.valid?(coin)
      request(:post, "/#{coin}_withdrawal", params)
    end

    # Return a deposit address for specific coin type.
    #
    # coin – The coin type
    def deposit_address coin, params={}
      raise ConfigurationError.new('No coin type specified') unless coin
      raise ConfigurationError.new('Invalid coin type specified') unless Coin.valid?(coin)
      request(:post, "/#{coin}_deposit_address", params)
    end


    # Return a list of user transactions.
    #
    # offset - optional, skip that many transactions before beginning to return results. Default: 0.
    # limit  - optional, limit result to that many transactions. Default: 50.
    # sort   - optional, sorting by date and time (asc - ascending; desc - descending). Default: desc.
    # book   - optional, if not specified, will default to btc_cad.
    def user_transactions params={}
      request(:post, '/user_transactions', params).each { |t| t.id = t.id.to_s }
    end
  end
end
