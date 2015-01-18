# QuadrigaCX

Ruby wrapper for the QuadrigaCX API

`gem install quadrigacx`

```
client = QuadrigaCX::Client.new(api_key: 'API_KEY', api_secret: 'API_SECRET)
client.order_book
```

Heavily inspired by [localbitcoins](https://github.com/pemulis/localbitcoins).
