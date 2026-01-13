defmodule ExCreem.WebhookTest do
  use ExUnit.Case
  alias ExCreem.Webhook

  test "verify_signature/3 checks signature correctly" do
    secret = "my_secret"
    payload = "payload"

    signature =
      :crypto.mac(:hmac, :sha256, secret, payload)
      |> Base.encode16(case: :lower)

    assert :ok == Webhook.verify_signature(payload, signature, secret)
  end

  test "verify_signature/3 fails on invalid signature" do
    assert {:error, :invalid_signature} ==
             Webhook.verify_signature("payload", "invalid", "secret")
  end
end
