require 'spec_helper'

describe QuadrigaCX::Client do
  subject(:client) { QuadrigaCX::Client.new(
    client_id:  ENV['QUADRIGACX_CLIENT_ID'],
    api_key:    ENV['QUADRIGACX_API_KEY'],
    api_secret: ENV['QUADRIGACX_API_SECRET'],
  )}

  def safe_limit_buy
    VCR.use_cassette('safe_limit_buy') do
      worst_price = client.order_book.bids.last[0]
      client.limit_buy(price: worst_price, amount: 1)
    end
  end

  def safe_limit_sell
    VCR.use_cassette('safe_limit_sell') do
      worst_price = client.order_book.asks.last[0]
      client.limit_sell(price: worst_price, amount: 0.01)
    end
  end

  describe 'public' do
    describe '#ticker' do
      it 'returns trading information' do
        VCR.use_cassette('ticker') do
          ticker = client.ticker

          expect(ticker.high).not_to be_nil
          expect(ticker.low).not_to be_nil
        end
      end
    end

    describe '#order_book' do
      it 'returns a list of all open orders' do
        VCR.use_cassette('order_book') do
          order_book = client.order_book

          expect(order_book.timestamp).not_to be_nil
          expect(order_book.bids.first.length).to equal 2
          expect(order_book.asks.first.length).to equal 2
        end
      end

      context 'when using the ungrouped option' do
        order = nil
        after { VCR.use_cassette('order_book_ungrouped_cancel_order') { client.cancel(id: order.id) if order }}

        it 'does not group same price orders' do
          VCR.use_cassette('order_book_ungrouped') do
            order = safe_limit_buy
            ungrouped_bids = client.order_book(group: 0).bids
            expect(ungrouped_bids[-2][0]).to eq(ungrouped_bids.last[0])
          end
        end
      end
    end

    describe '#transactions' do
      it 'returns a list of recent trades' do
        VCR.use_cassette('transactions') do
          transactions = client.transactions

          expect(transactions.first.date).not_to be_nil
          expect(transactions.first.price).not_to be_nil
        end
      end
    end
  end

  describe 'private' do
    describe '#balance' do
      it 'returns all account balances' do
        VCR.use_cassette('balance') do
          balance = client.balance

          expect(balance.cad_balance).not_to be_nil
          expect(balance.btc_balance).not_to be_nil
        end
      end
    end

    describe '#limit_buy' do
      order = nil
      after { VCR.use_cassette('limit_buy_cancel_order') { client.cancel(id: order.id) if order }}

      it 'throws an error when no price is provided' do
        expect { client.limit_buy }.to raise_error(QuadrigaCX::ConfigurationError)
      end

      it 'places a limit buy order' do
        VCR.use_cassette('limit_buy') do
          order = safe_limit_buy

          expect(order.datetime).not_to be_nil
          expect(order.id).not_to be_nil
        end
      end
    end

    describe '#limit_sell' do
      order = nil
      after { VCR.use_cassette('limit_sell_cancel_order') { client.cancel(id: order.id) if order }}

      it 'throws an error when no price is provided' do
        expect { client.limit_sell }.to raise_error(QuadrigaCX::ConfigurationError)
      end

      it 'places a limit sell order' do
        VCR.use_cassette('limit_sell') do
          order = safe_limit_sell

          expect(order.datetime).not_to be_nil
          expect(order.id).not_to be_nil
        end
      end
    end

    describe '#market_buy' do
      it 'places a market buy order' do
        VCR.use_cassette('market_buy') do
          response = client.market_buy(amount: 5.00) # 5 CAD

          expect(response.amount).not_to be_nil
          expect(response.orders_matched.first.price).not_to be_nil
        end
      end
    end

    describe '#cancel' do
      let(:order) { safe_limit_buy }

      it 'cancels an order' do
        VCR.use_cassette('cancel') do
          response = client.cancel(id: order.id)
          expect(response).to eq('true')
        end
      end
    end

    describe '#withdraw' do
      it 'withdraws bitcoins' do
        VCR.use_cassette('withdraw') do
          response = client.withdraw(amount: 0.01, address: '1FAs1ywa3pqS6S5mvypXjCtHAzwCkymNUX')
          expect(response).to eq('ok')
        end
      end
    end

    describe '#open_orders' do
      it 'lists open orders' do
        VCR.use_cassette('open_orders') do
          response = client.open_orders

          expect(response.first.datetime).not_to be_nil
          expect(response.first.price).not_to be_nil
          expect(response.first.type).not_to be_nil
        end
      end
    end

    describe '#wallet_address' do
      it 'returns a wallet address' do
        VCR.use_cassette('wallet_address') do
          response = client.wallet_address
          expect(response.length).to be_between(26, 35)
        end
      end
    end

    describe '#user_transactions' do
      it 'returns a list of transactions' do
        VCR.use_cassette('user_transactions') do
          response = client.user_transactions
          expect(response.first.id).to be_kind_of(String)
          expect(response.first.datetime).not_to be_nil
        end
      end

      it 'returns a list of limited transactions' do
        VCR.use_cassette('user_transactions_limited') do
          limit    = 1
          response = client.user_transactions(limit: limit)

          # For some reason the API is off by one.
          expect(response.length).to be (limit + 1)
        end
      end
    end
  end
end
