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

```ruby
ticker = subject.ticker
```

#### Order Book

```ruby
order_book = subject.order_book
order_book_ungrouped = subject.order_book(group: 0)
```

#### Transactions

```ruby
transactions = subject.transactions
```

### Private Methods

#### Balance

```ruby
balance = subject.balance
```

#### Limit Buy

```ruby
order = subject.limit_buy(price: 200, amount: 1)
```

#### Limit Sell

```ruby
order = subject.limit_sell(price: 200, amount: 1)
```

#### Market Buy

```ruby
order = subject.market_buy(amount: 1)
```

#### Cancel

```ruby
subject.cancel(order.id)
```

#### Withdraw

```ruby
response = subject.withdraw(amount: 1, address: '1FAs1ywa3pqS6S5mvypXjCtHAzwCkymNUX')
```

#### Open Orders

```ruby
response = subject.open_orders
```

#### Wallet Address

```ruby
response = subject.wallet_address
```

#### User Transactions

```ruby
response = subject.user_transactions
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/quadrigacx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
