# Quadrigacx

Ruby wrapper for the QuadrigaCX API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quadrigacx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quadrigacx

## Usage

```ruby
require 'quadrigacx'

QuadrigaCX.configure do |config|
  config.client_id  = 'your-client-id'
  config.api_key    = 'your-api-key'
  config.api_secret = 'your-api-secret'
end

client = QuadrigaCX::Client.new
```

### Public Methods

#### Ticker

Return trading information.

```ruby
ticker = client.ticker
```

#### Order Book

List all open orders.

```ruby
order_book = client.order_book
order_book_ungrouped = client.order_book(group: 0)
```

#### Transactions

Return descending JSON list of recent trades.

```ruby
transactions = client.transactions
```

### Private Methods

#### Balance

List all account balances.

```ruby
balance = client.balance
```

#### Limit Buy

Place a limit buy order. Returns JSON describing the order.

```ruby
order = client.limit_buy(price: 200, amount: 1)
```

#### Limit Sell

Place a limit sell order. Returns JSON describing the order.

```ruby
order = client.limit_sell(price: 200, amount: 1)
```

#### Market Buy

Place a market order. Returns JSON describing the order.

```ruby
order = client.market_buy(amount: 5.00)
```

#### Market Sell

Place a market order. Returns JSON describing the order.

```ruby
order = client.market_sell(amount: 0.01)
```

#### Cancel Order

Cancel an order.

```ruby
client.cancel_order(order.id)
```

#### Open Orders

Return a JSON list of open orders.

```ruby
response = client.open_orders
```

#### Withdraw Bitcoins

Withdraw bitcoins.

```ruby
response = client.bitcoin_withdraw(amount: 1, address: '1FAs1ywa3pqS6S5mvypXjCtHAzwCkymNUX')
```

#### Bitcoin Deposit Address

Return a bitcoin deposit address.

```ruby
response = client.bitcoin_deposit_address
```

#### Ether Withdraw

Withdraw ether.

```ruby
response = client.ether_withdraw(amount: 1, address: '1FAs1ywa3pqS6S5mvypXjCtHAzwCkymNUX')
```

#### Ether Deposit Address

Return an ether deposit address.

```ruby
response = client.ether_deposit_address
```

#### User Transactions

Return a list of user transactions.

```ruby
response = client.user_transactions
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/quadrigacx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
