# webhook_server.exs
# Run this script to start a local webhook server:
#   elixir webhook_server.exs
#
# You can test it using curl:
#   curl -X POST http://localhost:4000/webhooks \
#     -H "Content-Type: application/json" \
#     -H "x-creem-signature: <signature>" \
#     -d '{"id":"evt_test"}'

Mix.install([
  {:ex_creem, path: "."},
  {:plug_cowboy, "~> 2.6"}, # Using Cowboy as the server
  {:jason, "~> 1.4"}
])

defmodule WebhookRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/webhooks" do
    # 1. Read the raw body (needed for signature verification)
    {:ok, body, conn} = Plug.Conn.read_body(conn, length: 1_000_000)
    
    # 2. Get the signature from headers
    [signature] = Plug.Conn.get_req_header(conn, "x-creem-signature") || [""]
    
    # 3. Your Webhook Secret (from Creem Dashboard)
    # In a real app, load this from config/env
    webhook_secret = System.get_env("CREEM_WEBHOOK_SECRET") || "whsec_test_secret"

    IO.puts("\n📩 Received Webhook!")
    
    # 4. Verify and Parse
    case ExCreem.Webhook.construct_event(body, signature, webhook_secret) do
      {:ok, event} ->
        IO.puts("✅ Signature Verified!")
        IO.puts("   Event Type: #{event["type"] || "unknown"}")
        IO.puts("   Event ID: #{event["id"]}")
        IO.inspect(event, label: "   Payload")

        send_resp(conn, 200, "Webhook received")
        
      {:error, :invalid_signature} ->
        IO.puts("❌ Invalid Signature!")
        send_resp(conn, 400, "Invalid signature")
        
      {:error, reason} ->
        IO.puts("❌ Error parsing webhook: #{inspect(reason)}")
        send_resp(conn, 400, "Bad request")
    end
  end

  # Default fallback
  match _ do
    send_resp(conn, 404, "Not found")
  end
end

IO.puts("🚀 Webhook Server running on http://localhost:4000/webhooks")
IO.puts("   (Press Ctrl+C to stop)")
IO.puts("   Using Webhook Secret: #{System.get_env("CREEM_WEBHOOK_SECRET") || "whsec_test_secret"}")

Plug.Cowboy.http WebhookRouter, [], port: 4000
