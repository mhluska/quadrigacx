module QuadrigaCX
  module Public
    # List all open orders
    #
    # book  - optional, book to return orders for. Default btc_cad.
    # group - optional, group orders with the same price (0 - false; 1 - true). Default: 1.
    def order_book params={}
      request(:get, '/order_book', params)
    end

    # Returns descending JSON list of recent trades
    #
    # book - optional, book to return orders for (default btc_cad)
    # time - optional, time frame for transaction export ("minute" - 1 minute, "hour" - 1 hour). Default: hour.
    def transactions params={}
      request(:get, '/transactions', params)
    end
  end
end

