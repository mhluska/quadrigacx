require 'spec_helper'

describe QuadrigaCX::Client do
  subject(:client) { QuadrigaCX::Client.new(
    client_id:  ENV['QUADRIGACX_CLIENT_ID'],
    api_key:    ENV['QUADRIGACX_API_KEY'],
    api_secret: ENV['QUADRIGACX_API_SECRET'],
  )}

  describe 'public' do
    describe '#order_book' do
      it 'returns a list of all open orders' do
        VCR.use_cassette('order_book') do
          order_book = client.order_book

          expect(order_book.timestamp).not_to be_nil
          expect(order_book.bids.first.length).to equal 2
          expect(order_book.asks.first.length).to equal 2
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
      it 'throws an error when no price is provided' do
        expect { client.limit_buy }.to raise_error(QuadrigaCX::ConfigurationError)
      end

      it 'places a limit buy order' do
        VCR.use_cassette('limit_buy') do
          response = client.limit_buy(price: '240', amount: '0.01') # 0.01 BTC

          expect(response.datetime).not_to be_nil
          expect(response.id).not_to be_nil
        end
      end
    end

    describe '#limit_sell' do
      it 'throws an error when no price is provided' do
        expect { client.limit_sell }.to raise_error(QuadrigaCX::ConfigurationError)
      end

      it 'places a limit sell order' do
        VCR.use_cassette('limit_sell') do
          response = client.limit_sell(price: '240', amount: '0.01') # 0.01 BTC

          expect(response.datetime).not_to be_nil
          expect(response.id).not_to be_nil
        end
      end
    end

    describe '#market_buy' do
      it 'places a market buy order' do
        VCR.use_cassette('market_buy') do
          response = client.market_buy(amount: '5.00') # 5 CAD

          expect(response.amount).not_to be_nil
          expect(response.orders_matched.first.price).not_to be_nil
        end
      end
    end

    describe '#cancel_order' do
      let(:order) { client.limit_buy(price: '240', amount: '0.01') }

      it 'cancels an order' do
        VCR.use_cassette('cancel_order') do
          response = client.cancel(id: order.id)
          expect(response).to eq('"true"')
        end
      end
    end

    describe '#withdraw' do
      it 'withdraws bitcoins' do
        VCR.use_cassette('withdraw') do
          response = client.withdraw(amount: '0.01', address: '1FAs1ywa3pqS6S5mvypXjCtHAzwCkymNUX')
          expect(response).to eq('"ok"')
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
  end
end
