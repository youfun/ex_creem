# ExCreem Payment Testing Guide (Test Mode)

This guide explains how to use the ExCreem library in test mode and complete simulated payment flows.

## 1. Library Configuration

In test mode, make sure API requests are sent to Creem's test servers. ExCreem supports switching to the test environment automatically via the `test_mode: true` option.

### Example (manual config)
```elixir
opts = [
  api_key: "creem_test_...", # Use a key starting with creem_test_
  test_mode: true
]

# Create a checkout session
{:ok, session} = ExCreem.Resources.Checkout.create(%{
  "product_id" => "prod_...",
  "success_url" => "http://localhost:4000/success"
}, opts)
```

---

## 2. Using the creem_test.exs Test Page

We provide an interactive test page `creem_test.exs`.

1. **Run the page**:
   ```bash
   elixir creem_test.exs
   ```
2. **Open the page**: Visit `http://localhost:4000` in your browser.
3. **Enter parameters**:
   - **API Key**: Enter your `creem_test_...` key.
   - **Product ID**: Enter the test product ID created in the Creem dashboard.
   - **Enable Test Mode**: Check this option (checked by default).
4. **Generate Link**: Click "Generate Checkout URL", then click the generated green link to access the Creem-hosted checkout page.

---

## 3. Test Card Numbers

On the test checkout page you can use the following card numbers to simulate different outcomes.
Expiry date: any future date (e.g., `12/26`).
CVC: any 3 digits (e.g., `123`).
Billing info: any values.

| Card Number | Expected Behavior |
| :--- | :--- |
| `4242 4242 4242 4242` | Success |
| `4000 0000 0000 0002` | Card declined |
| `4000 0000 0000 9995` | Insufficient funds |
| `4000 0000 0000 0127` | Incorrect CVC |
| `4000 0000 0000 0069` | Expired card |

---

## 4. Webhook Testing

To test post-payment callbacks:
1. Configure a **Test Webhook URL** in the Creem dashboard.
2. Use `webhook_server.exs` to start a local webhook receiver.
3. Expose your local port (default 4000) to the public internet with `ngrok` or a similar tool, and set that URL in the Creem dashboard.

---

## 5. FAQ

- **400 error (property productId should not exist)**: Use `product_id` (snake_case) instead of `productId`.
- **400 error (property cancel_url should not exist)**: Creem's Checkout API does not accept a `cancel_url` parameter—remove it.
- **Authorization errors**: Verify your API key and ensure it matches `test_mode` (test keys must start with `creem_test_`).
