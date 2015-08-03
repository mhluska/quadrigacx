require 'spec_helper'

describe QuadrigaCX::Client, :vcr do
  def safe_limit_buy
    worst_price = subject.order_book.bids.last[0]
    subject.limit_buy(price: worst_price, amount: 1)
  end

  def safe_limit_sell
    worst_price = subject.order_book.asks.last[0]
    subject.limit_sell(price: worst_price, amount: 0.01)
  end

  describe 'public' do
    describe '#ticker' do
      it 'returns trading information' do
        ticker = subject.ticker

        expect(ticker.high).not_to be_nil
        expect(ticker.low).not_to be_nil
      end
    end

    describe '#order_book' do
      it 'returns a list of all open orders' do
        order_book = subject.order_book

        expect(order_book.timestamp).not_to be_nil
        expect(order_book.bids.first.length).to equal 2
        expect(order_book.asks.first.length).to equal 2
      end

      context 'when using the ungrouped option' do
        order = nil
        after { subject.cancel(id: order.id) }

        it 'does not group same price orders' do
          order = safe_limit_buy
          ungrouped_bids = subject.order_book(group: 0).bids
          expect(ungrouped_bids[-2][0]).to eq(ungrouped_bids.last[0])
        end
      end
    end

    describe '#transactions' do
      it 'returns a list of recent trades' do
        transactions = subject.transactions

        expect(transactions.first.date).not_to be_nil
        expect(transactions.first.price).not_to be_nil
      end
    end
  end

  describe 'private' do
    describe '#balance' do
      it 'returns all account balances' do
        balance = subject.balance

        expect(balance.cad_balance).not_to be_nil
        expect(balance.btc_balance).not_to be_nil
      end
    end

    describe '#limit_buy' do
      describe 'errors' do
        it 'throws an error when no price is provided' do
          expect { subject.limit_buy }.to raise_error(QuadrigaCX::ConfigurationError)
        end

        it 'throws an error when exceeding balance' do
          expect { subject.limit_buy(price: 1_000_000, amount: 1) }.to raise_error(QuadrigaCX::AboveMaximumOrderValue)
        end

        it 'throws an error when the amount is too small' do
          expect { subject.limit_buy(price: 100, amount: 0.00000001) }.to raise_error(QuadrigaCX::BelowMinimumOrderValue)
        end

        it 'throws an error when exceeding available balance' do
          expect { subject.limit_buy(price: 4999, amount: 1) }.to raise_error(QuadrigaCX::ExceedsAvailableBalance)
        end
      end

      let(:order) { safe_limit_buy }
      after { subject.cancel(id: order.id) }

      it 'places a limit buy order' do
        expect(order.datetime).not_to be_nil
        expect(order.id).not_to be_nil
      end
    end

    describe '#limit_sell' do
      describe 'errors' do
        it 'throws an error when no price is provided' do
          expect { subject.limit_sell }.to raise_error(QuadrigaCX::ConfigurationError)
        end
      end

      let(:order) { safe_limit_sell }
      after { subject.cancel(id: order.id) }

      it 'places a limit sell order' do
        expect(order.datetime).not_to be_nil
        expect(order.id).not_to be_nil
      end
    end

    describe '#market_buy' do
      it 'places a market buy order' do
        response = subject.market_buy(amount: 5.00) # 5 CAD

        expect(response.amount).not_to be_nil
        expect(response.orders_matched.first.price).not_to be_nil
      end
    end

    describe '#cancel' do
      let(:order) { safe_limit_buy }

      it 'cancels an order' do
        response = subject.cancel(id: order.id)
        expect(response).to be true
      end
    end

    describe '#withdraw' do
      it 'withdraws bitcoins' do
        response = subject.withdraw(amount: 0.01, address: '1DVLFma28jEgTCUjQ32FUYe12bRzvywAfr')
        expect(response).to eq('ok')
      end
    end

    describe '#open_orders' do
      order = nil
      before { order = safe_limit_buy }
      after { subject.cancel(id: order.id) }

      it 'lists open orders' do
        response = subject.open_orders

        expect(response.first.datetime).not_to be_nil
        expect(response.first.price).not_to be_nil
        expect(response.first.type).not_to be_nil
      end
    end

    describe '#wallet_address' do
      it 'returns a wallet address' do
        response = subject.wallet_address
        expect(response.length).to be_between(26, 35)
      end
    end

    describe '#user_transactions' do
      it 'returns a list of transactions' do
        response = subject.user_transactions
        expect(response.first.id).to be_kind_of(String)
        expect(response.first.datetime).not_to be_nil
      end

      it 'returns a list of limited transactions' do
        limit    = 1
        response = subject.user_transactions(limit: limit)

        # For some reason the API is off by one.
        expect(response.length).to be (limit + 1)
      end
    end
  end
end
