module QuadrigaCX
  module Private
    # List all account balances
    #
    def balance
      request(:post, '/balance')
    end
  end
end
