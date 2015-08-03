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

client = QuadrigaCX.new
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
order = client.market_buy(amount: 1)
```

#### Market Sell

Place a market order. Returns JSON describing the order.

```ruby
order = client.market_sell(amount: 1)
```

#### Cancel

Cancel an order.

```ruby
client.cancel(order.id)
```

#### Withdraw

Withdraw bitcoins.

```ruby
response = client.withdraw(amount: 1, address: '1FAs1ywa3pqS6S5mvypXjCtHAzwCkymNUX')
```

#### Open Orders

Return a JSON list of open orders.

```ruby
response = client.open_orders
```

#### Wallet Address

Return a bitcoin deposit address.

```ruby
response = client.wallet_address
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
