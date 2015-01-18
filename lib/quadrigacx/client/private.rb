module QuadrigaCX
  module Private
    # List all account balances
    #
    def balance(params={})
      request(:post, '/balance', params)
    end
  end
end
