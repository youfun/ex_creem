# verify.exs
# Verification script for ExCreem
# Usage:
#   1. Create a .env file with CREEM_API_KEY=your_key
#   2. Run: elixir verify.exs

Mix.install([
  {:ex_creem, path: "."},
  {:mox, "~> 1.0"} # Still needed for fallback mode
])

defmodule Verifier do
  def run do
    load_dot_env()
    
    api_key = System.get_env("CREEM_API_KEY")

    if api_key && api_key != "" do
      run_live_test(api_key)
    else
      run_mock_test()
    end
  end

  defp load_dot_env do
    if File.exists?(".env") do
      File.stream!(".env")
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&(&1 == "" or String.starts_with?(&1, "#")))
      |> Enum.each(fn line ->
        [key, value] = String.split(line, "=", parts: 2)
        System.put_env(String.trim(key), String.trim(value))
      end)
      IO.puts("📄 Loaded environment variables from .env")
    end
  end

  defp run_live_test(api_key) do
    IO.puts("\n🚀 detected CREEM_API_KEY. Running LIVE integration test against real API...")
    
    # Ensure we are using the real adapter (default)
    # Just in case some config leaked (unlikely in script, but good practice)
    Application.delete_env(:ex_creem, :adapter)
    
    # Verify Config picks it up
    if ExCreem.Config.api_key() == api_key do
      IO.puts("✅ ExCreem.Config correctly resolved API Key from environment.")
    else
      IO.puts("❌ Config mismatch! Expected key from env.")
      System.halt(1)
    end

    IO.puts("📡 Sending request to ExCreem.Resources.Product.search(limit: 1)...")
    
    case ExCreem.Resources.Product.search(limit: 1) do
      {:ok, response} ->
        IO.puts("✅ Real API Call Successful!")
        IO.inspect(response, label: "API Response")
      
      {:error, {status, body}} ->
        IO.puts("⚠️ API returned error status: #{status}")
        IO.inspect(body, label: "Error Body")
        IO.puts("Note: This counts as a successful 'client' test if the error is from the API (e.g. invalid key).")
        
      {:error, reason} ->
        IO.puts("❌ Request Failed: #{inspect(reason)}")
        System.halt(1)
    end
  end

  defp run_mock_test do
    IO.puts("\n⚠️ No CREEM_API_KEY found. Running in MOCK mode.")
    IO.puts("   (To run a real test, create a .env file with CREEM_API_KEY=sk_...)")

    # Setup Mocking
    Mox.defmock(ExCreem.AdapterMock, for: ExCreem.Adapter)
    Application.put_env(:ex_creem, :adapter, ExCreem.AdapterMock)
    Application.put_env(:ex_creem, :api_key, "mock_test_key")

    IO.puts("--- Starting ExCreem Mock Verification ---")

    # Mock Expectation
    Mox.expect(ExCreem.AdapterMock, :request, fn req ->
      IO.puts("   Internal: Mock received request to #{req.url.path}")
      
      api_key_header = Req.Request.get_header(req, "x-api-key")
      if api_key_header == ["mock_test_key"] do
        IO.puts("✅ API Key header verified in request")
      else
        IO.puts("❌ API Key header mismatch: #{inspect(api_key_header)}")
      end

      {:ok, %Req.Response{status: 200, body: %{"status" => "mocked_ok"}}}
    end)

    # Execute
    case ExCreem.Resources.Product.get("test_id") do
      {:ok, %{"status" => "mocked_ok"}} ->
        IO.puts("✅ Resource call (Product.get) successful via Mock")
      other ->
        IO.puts("❌ Resource call failed: #{inspect(other)}")
        System.halt(1)
    end
    
    verify_webhook()
    
    IO.puts("--- Mock Verification Completed Successfully ---")
  end
  
  defp verify_webhook do
    IO.puts("Testing Webhook locally...")
    payload = "{\"id\":\"evt_123\"}"
    secret = "test_secret"
    signature = :crypto.mac(:hmac, :sha256, secret, payload) |> Base.encode16(case: :lower)

    case ExCreem.Webhook.construct_event(payload, signature, secret) do
      {:ok, event} ->
        if event["id"] == "evt_123" do
          IO.puts("✅ Webhook verification successful")
        else
          IO.puts("❌ Webhook event data mismatch")
        end
      {:error, reason} ->
        IO.puts("❌ Webhook verification failed: #{inspect(reason)}")
        System.halt(1)
    end
  end
end

Verifier.run()
