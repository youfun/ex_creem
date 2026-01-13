defmodule ExCreem.Resources.CheckoutTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.Checkout

  setup :verify_on_exit!

  test "create/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/checkouts"
      assert req.options[:json] == %{product_id: "prod_123"}
      {:ok, %Req.Response{status: 200, body: %{"id" => "ch_123"}}}
    end)

    assert {:ok, %{"id" => "ch_123"}} = Checkout.create(%{product_id: "prod_123"})
  end

  test "get/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/checkouts/ch_123"
      {:ok, %Req.Response{status: 200, body: %{"id" => "ch_123"}}}
    end)

    assert {:ok, %{"id" => "ch_123"}} = Checkout.get("ch_123")
  end
end
