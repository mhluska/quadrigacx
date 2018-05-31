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
    def limit_buy(params = {})
      raise ConfigurationError.new('No price specified for limit buy') unless params[:price]
      request(:post, '/buy', params)
    end

    # Place a limit sell order. Returns JSON describing the order.
    #
    # amount - amount of major currency.
    # price  - price to sell at.
    # book   - optional, if not specified, will default to btc_cad.
    def limit_sell(params = {})
      raise ConfigurationError.new('No price specified for limit sell') unless params[:price]
      request(:post, '/sell', params)
    end

    # Place a market order. Returns JSON describing the order.
    #
    # amount - amount of major currency to spend.
    # book   - optional, if not specified, will default to btc_cad.
    def market_buy(params = {})
      request(:post, '/buy', params)
    end

    # Place a market order. Returns JSON describing the order.
    #
    # amount - amount of major currency to sell.
    # book   - optional, if not specified, will default to btc_cad.
    def market_sell(params = {})
      request(:post, '/sell', params)
    end

    # Cancel an order.
    #
    # id – a 64 characters long hexadecimal string taken from the list of orders.
    def cancel_order(params = {})
      request(:post, '/cancel_order', params)
    end

    # Return a JSON list of open orders.
    #
    # book - optional, if not specified, will default to btc_cad.
    def open_orders(params = {})
      request(:post, '/open_orders', params)
    end

    # Withdraw bitcoins.
    #
    # amount  – The amount to withdraw.
    # address – The bitcoin address we will send the amount to.
    def bitcoin_withdraw(params = {})
      request(:post, '/bitcoin_withdrawal', params)
    end

    # Return a bitcoin deposit address.
    def bitcoin_deposit_address(params = {})
      request(:post, '/bitcoin_deposit_address', params)
    end

    # Withdraw ether.
    #
    # amount  – The amount to withdraw.
    # address – The ether address we will send the amount to.
    def ether_withdraw(params = {})
      request(:post, '/ether_withdrawal', params)
    end

    # Return a ether deposit address.
    def ether_deposit_address(params = {})
      request(:post, '/ether_deposit_address', params)
    end

    # Withdraw litecoin.
    #
    # amount  – The amount to withdraw.
    # address – The litecoin address we will send the amount to.
    def litecoin_withdraw(params = {})
      request(:post, '/litecoin_withdrawal', params)
    end

    # Return a litecoin deposit address.
    def litecoin_deposit_address(params = {})
      request(:post, '/litecoin_deposit_address', params)
    end

    # Return a list of user transactions.
    #
    # offset - optional, skip that many transactions before beginning to return results. Default: 0.
    # limit  - optional, limit result to that many transactions. Default: 50.
    # sort   - optional, sorting by date and time (asc - ascending; desc - descending). Default: desc.
    # book   - optional, if not specified, will default to btc_cad.
    def user_transactions(params = {})
      request(:post, '/user_transactions', params).each { |t| t.id = t.id.to_s }
    end
  end
end
