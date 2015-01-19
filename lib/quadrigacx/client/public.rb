module QuadrigaCX
  module Public
    # List all open orders
    #
    # book  - optional, book to return orders for. Default btc_cad.
    # group - optional, group orders with the same price (0 - false; 1 - true). Default: 1.
    def order_book params={}
      request(:get, '/order_book', params)
    end
  end
end

