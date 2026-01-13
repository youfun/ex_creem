defmodule ExCreem.Webhook do
  @moduledoc """
  Webhook verification.
  """

  def verify_signature(payload, signature, secret) do
    expected_signature =
      :crypto.mac(:hmac, :sha256, secret, payload)
      |> Base.encode16(case: :lower)

    if secure_compare(signature, expected_signature) do
      :ok
    else
      {:error, :invalid_signature}
    end
  end

  def construct_event(payload, signature, secret) do
    case verify_signature(payload, signature, secret) do
      :ok -> Jason.decode(payload)
      error -> error
    end
  end

  defp secure_compare(left, right) do
    if byte_size(left) == byte_size(right) do
      :crypto.hash_equals(left, right)
    else
      false
    end
  end
end
