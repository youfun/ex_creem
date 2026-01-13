defmodule ExCreem.E2ETest do
  use ExUnit.Case
  @moduletag :e2e

  # Only run if API key is present
  @api_key System.get_env("CREEM_API_KEY")

  setup do
    if @api_key do
      # Ensure we are using the real adapter (Req)
      Application.put_env(:ex_creem, :adapter, ExCreem.Adapter.Req)
      Application.put_env(:ex_creem, :api_key, @api_key)
      :ok
    else
      {:skip, "CREEM_API_KEY not set"}
    end
  end

  test "fetches products from real API" do
    # We use search to avoid needing a specific ID
    # This assumes the API key has access to list products
    assert {:ok, _response} = ExCreem.Resources.Product.search(limit: 1)
  end

  # Add more E2E tests here as needed
  # For example, creating a dummy product and deleting it (if API supports it)
  # But be careful with E2E tests creating garbage data
end
