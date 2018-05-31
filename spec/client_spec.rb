require 'spec_helper'

describe QuadrigaCX::Client, :vcr do
  def safe_limit_buy book: :btc_cad
    worst_price = subject.order_book.bids.last[0]
    subject.limit_buy(price: worst_price, amount: 1, book: book)
  end

  def safe_limit_sell book: :btc_cad
    worst_price = subject.order_book.asks.last[0]
    subject.limit_sell(price: worst_price, amount: 0.01, book: book)
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
      let(:order_book_cad) { subject.order_book }
      let(:order_book_usd) { subject.order_book(book: :btc_usd) }

      it 'returns a list of all open orders' do
        expect(order_book_cad.timestamp).not_to be_nil
        expect(order_book_cad.bids.first.length).to equal 2
        expect(order_book_cad.asks.first.length).to equal 2
      end

      it 'returns a USD order book' do
        expect(order_book_usd.bids.first).to_not equal(order_book_cad.bids.first)
      end

      context 'when using the group option' do
        let!(:order) { safe_limit_buy }
        after { subject.cancel_order(id: order.id) }

        it 'does not group same price orders' do
          ungrouped_bids = subject.order_book(group: 0).bids
          expect(ungrouped_bids[-2][0]).to eq(ungrouped_bids.last[0])
        end
      end
    end

    describe '#transactions' do
      let(:transactions_cad) { subject.transactions }
      let(:transactions_usd) { subject.transactions(book: :btc_usd) }

      it 'returns a list of recent trades' do
        expect(transactions_cad.first.date).not_to be_nil
        expect(transactions_cad.first.price).not_to be_nil
      end

      it 'returns a list of USD trades' do
        expect(transactions_usd.first.price).not_to equal(transactions_cad.first.price)
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

      let(:order_cad) { safe_limit_buy }
      let(:order_usd) { safe_limit_buy(book: :btc_usd) }

      after { subject.cancel_order(id: order_cad.id) && subject.cancel_order(id: order_usd.id) }

      it 'places a limit buy order_cad' do
        expect(order_cad.datetime).not_to be_nil
        expect(order_cad.id).not_to be_nil
        expect(order_cad.price).not_to be_nil
      end

      it 'places a USD limit buy order' do
        expect(order_cad.price).not_to equal(order_usd.price)
      end
    end

    describe '#limit_sell' do
      describe 'errors' do
        it 'throws an error when no price is provided' do
          expect { subject.limit_sell }.to raise_error(QuadrigaCX::ConfigurationError)
        end
      end

      let(:order_cad) { safe_limit_sell }
      let(:order_usd) { safe_limit_sell(book: :btc_usd) }

      after { subject.cancel_order(id: order_cad.id) && subject.cancel_order(id: order_usd.id) }

      it 'places a limit sell order' do
        expect(order_cad.datetime).not_to be_nil
        expect(order_cad.id).not_to be_nil
        expect(order_cad.price).not_to be_nil
      end

      it 'places a USD limit sell order' do
        expect(order_cad.price).not_to equal(order_usd.price)
      end
    end

    describe '#market_buy' do
      let(:market_buy_cad) { subject.market_buy(amount: 5.00) }
      let(:market_buy_usd) { subject.market_buy(amount: 5.00, book: :btc_usd) }

      it 'places a market buy order' do
        expect(market_buy_cad.amount).not_to be_nil
        expect(market_buy_cad.orders_matched.first.price).not_to be_nil
      end

      it 'places a USD market buy order' do
        expect(market_buy_cad.orders_matched.first.price).not_to equal(market_buy_usd.orders_matched.first.price)
      end
    end

    describe '#market_sell' do
      let(:market_sell_cad) { subject.market_sell(amount: 0.01) }
      let(:market_sell_usd) { subject.market_sell(amount: 0.01, book: :btc_usd) }

      it 'places a market sell order' do
        expect(market_sell_cad.amount).not_to be_nil
        expect(market_sell_cad.orders_matched.first.price).not_to be_nil
      end

      it 'places a USD market sell order' do
        expect(market_sell_cad.orders_matched.first.price).not_to equal(market_sell_usd.orders_matched.first.price)
      end
    end

    describe '#cancel_order' do
      let(:order) { safe_limit_buy }

      it 'cancels an order' do
        response = subject.cancel_order(id: order.id)
        expect(response).to be true
      end
    end

    describe '#open_orders' do
      let(:open_orders_cad) { subject.open_orders }
      let(:open_orders_usd) { subject.open_orders(book: :btc_usd) }
      let!(:orders) { [safe_limit_buy, safe_limit_buy(book: :btc_usd)] }

      after { orders.each { |order| subject.cancel_order(id: order.id) }}

      it 'lists open orders' do
        expect(open_orders_cad.first.datetime).not_to be_nil
        expect(open_orders_cad.first.type).not_to be_nil
        expect(open_orders_cad.first.price).not_to be_nil
      end

      it 'lists USD open orders' do
        expect(open_orders_cad.first.price).not_to equal open_orders_usd.first.price
      end
    end

    describe '#bitcoin_withdraw' do
      it 'withdraws bitcoins' do
        response = subject.bitcoin_withdraw(amount: 0.01, address: '1DVLFma28jEgTCUjQ32FUYe12bRzvywAfr')
        expect(response).to eq('ok')
      end
    end

    describe '#bitcoin_deposit_address' do
      it 'returns a bitcoin deposit address' do
        response = subject.bitcoin_deposit_address
        expect(response.length).to be_between(26, 35)
      end
    end

    describe '#ether_withdraw' do
      it 'withdraws ether' do
        response = subject.ether_withdraw(amount: 0.01, address: '1DVLFma28jEgTCUjQ32FUYe12bRzvywAfr')
        expect(response).to eq('ok')
      end
    end

    describe '#ether_deposit_address' do
      it 'returns an ether deposit address' do
        response = subject.ether_deposit_address
        expect(response.length).to be_between(26, 35)
      end
    end

    describe '#litecoin_withdraw' do
      it 'withdraws litecoins' do
        response = subject.litecoin_withdraw(amount: 0.01, address: '1DVLFma28jEgTCUjQ32FUYe12bRzvywAfr')
        expect(response).to eq('ok')
      end
    end

    describe '#litecoin_deposit_address' do
      it 'returns a litecoin deposit address' do
        response = subject.litecoin_deposit_address
        expect(response.length).to be_between(26, 35)
      end
    end

    describe '#user_transactions' do
      let(:user_transactions_cad) { subject.user_transactions }
      let(:user_transactions_usd) { subject.user_transactions(order_book: :btc_usd) }

      it 'returns a list of transactions' do
        expect(user_transactions_cad.first.id).to be_kind_of(String)
        expect(user_transactions_cad.first.datetime).not_to be_nil
        expect(user_transactions_cad.first.rate).not_to be_nil
      end

      it 'returns a list of USD transactions' do
        expect(user_transactions_cad.first.rate).not_to equal(user_transactions_usd.first.rate)
      end

      it 'returns a list of limited transactions' do
        limit    = 5
        response = subject.user_transactions(limit: limit)
        expect(response.length).to equal limit
      end
    end
  end
end
