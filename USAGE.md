# ExCreem Usage Guide

This guide provides a comprehensive overview of the `ex_creem` library's API.

## Installation & Configuration

Add `ex_creem` to your `mix.exs`:

```elixir
{:ex_creem, "~> 0.1.0"}
```

Configure your API key in `config/config.exs`:

```elixir
config :ex_creem,
  api_key: "creem_..."
```

## Resources

### Checkouts

Create a checkout session to accept payments.

```elixir
{:ok, session} = ExCreem.Resources.Checkout.create(%{
  product_id: "prod_123",
  success_url: "https://example.com/success",
  cancel_url: "https://example.com/cancel"
})

# Access the checkout URL
checkout_url = session["checkout_url"]
```

Retrieve a checkout session details:

```elixir
{:ok, session} = ExCreem.Resources.Checkout.get("checkout_id")
```

### Products

Manage your product catalog.

```elixir
# Create a product
{:ok, product} = ExCreem.Resources.Product.create(%{
  name: "Pro Plan",
  price: 5000, # in cents
  currency: "USD",
  type: "service"
})

# Get a product by ID
{:ok, product} = ExCreem.Resources.Product.get("prod_123")

# Search for products
{:ok, products} = ExCreem.Resources.Product.search(limit: 10)
```

### Customers

Manage customer information and billing portals.

```elixir
# Get a customer
{:ok, customer} = ExCreem.Resources.Customer.get("cust_123")

# List customers
{:ok, customers} = ExCreem.Resources.Customer.list(limit: 20)

# Create a billing portal session for a customer to manage their subscription
{:ok, portal} = ExCreem.Resources.Customer.create_billing_portal(%{
  customer_id: "cust_123",
  return_url: "https://example.com/dashboard"
})
```

### Subscriptions

Manage recurring billing.

```elixir
# Get a subscription
{:ok, sub} = ExCreem.Resources.Subscription.get("sub_123")

# Update a subscription (e.g., change metadata)
{:ok, sub} = ExCreem.Resources.Subscription.update("sub_123", %{
  metadata: %{internal_id: "456"}
})

# Cancel a subscription
{:ok, result} = ExCreem.Resources.Subscription.cancel("sub_123")

# Upgrade a subscription
{:ok, result} = ExCreem.Resources.Subscription.upgrade("sub_123", %{
  new_product_id: "prod_premium"
})
```

### Licenses

Handle software licensing.

```elixir
# Activate a license
{:ok, activation} = ExCreem.Resources.License.activate(%{
  license_key: "LICENSE-KEY",
  instance_id: "device-123"
})

# Validate a license
{:ok, validation} = ExCreem.Resources.License.validate(%{
  license_key: "LICENSE-KEY",
  instance_id: "device-123"
})

# Deactivate a license
{:ok, deactivation} = ExCreem.Resources.License.deactivate(%{
  license_key: "LICENSE-KEY",
  instance_id: "device-123"
})
```

### Discounts

Manage discount codes.

```elixir
# Create a discount
{:ok, discount} = ExCreem.Resources.Discount.create(%{
  code: "SUMMER2024",
  amount: 2000,
  type: "flat"
})

# Get a discount
{:ok, discount} = ExCreem.Resources.Discount.get("discount_id")

# Delete a discount
{:ok, _} = ExCreem.Resources.Discount.delete("discount_id")
```

### Transactions

Search through transaction history.

```elixir
{:ok, transactions} = ExCreem.Resources.Transaction.search(limit: 50)
```

## Webhooks

Handle incoming webhooks from Creem securely.

```elixir
defmodule MyAppWeb.WebhookController do
  use MyAppWeb, :controller

  def handle(conn, _params) do
    # Get the raw body (ensure your parser doesn't consume it first!)
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    
    signature = Plug.Conn.get_req_header(conn, "x-creem-signature") |> List.first()
    secret = System.get_env("CREEM_WEBHOOK_SECRET")

    case ExCreem.Webhook.construct_event(body, signature, secret) do
      {:ok, event} ->
        # proccess_event(event)
        send_resp(conn, 200, "OK")
      
      {:error, _reason} ->
        send_resp(conn, 400, "Bad Request")
    end
  end
end
```
