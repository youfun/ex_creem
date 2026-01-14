# ExCreem

ExCreem is a modern Elixir client for the [Creem API](https://creem.io), providing a simple and idiomatic way to manage products, checkouts, subscriptions, licenses, and more.

## Features

- **Full Resource Support**: Products, Checkouts, Customers, Licenses, Subscriptions, Discounts, and Transactions.
- **Webhook Handling**: Easy verification and processing of Creem webhooks.
- **Built on Req**: Leverages the powerful `Req` library for HTTP requests.
- **Mockable**: Designed with testing in mind using a pluggable adapter.

## Installation

Add `ex_creem` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_creem, "~> 0.1.0"}  目前在gith上https://github.com/youfun/ex_creem/
  ]
end
```

## Configuration

Configure ExCreem in your `config/config.exs` or `config/runtime.exs`:

```elixir
config :ex_creem,
  api_key: "your_api_key_here",
  test_mode: false # Set to true to use the test API environment
```

Alternatively, you can set the `CREEM_API_KEY` environment variable.

## Usage

### Products

```elixir
# Create a product
{:ok, product} = ExCreem.Resources.Product.create(%{
  name: "Premium Subscription",
  price: 2900,
  currency: "USD",
  interval: "month"
})

# Get a product
{:ok, product} = ExCreem.Resources.Product.get("prod_123")
```

### Checkouts

```elixir
# Create a checkout session
{:ok, session} = ExCreem.Resources.Checkout.create(%{
  product_id: "prod_123",
  success_url: "https://example.com/success",
  cancel_url: "https://example.com/cancel"
})

IO.puts "Checkout URL: #{session["checkout_url"]}"
```

### Webhooks

ExCreem provides a utility to verify and parse webhooks:

```elixir
payload = "..." # Raw request body
signature = "..." # Content of 'x-creem-signature' header
secret = "your_webhook_secret"

case ExCreem.Webhook.construct_event(payload, signature, secret) do
  {:ok, event} ->
    # Handle the event (e.g., event["type"] == "subscription.created")
    IO.inspect(event)
  {:error, :invalid_signature} ->
    # Handle invalid signature
end
```

## Testing

ExCreem uses `Mox` for mocking. In your tests, you can define mocks for the `ExCreem.Adapter` behaviour.

## License

MIT