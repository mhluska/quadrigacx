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
  end
end
