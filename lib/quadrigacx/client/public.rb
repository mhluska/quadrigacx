module QuadrigaCX
  module Public
    # List all open orders
    #
    # - Optional fields -
    # book  - book to return orders for. Default btc_cad.
    # group - group orders with the same price (0 - false; 1 - true). Default: 1.
    def order_book(params={})
      request(:get, '/order_book', params)
    end
  end
end

