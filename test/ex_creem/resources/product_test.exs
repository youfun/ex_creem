defmodule ExCreem.Resources.ProductTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.Product

  setup :verify_on_exit!

  test "create/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/products"
      assert req.options[:json] == %{name: "Test Product"}
      {:ok, %Req.Response{status: 201, body: %{"id" => "prod_123"}}}
    end)

    assert {:ok, %{"id" => "prod_123"}} = Product.create(%{name: "Test Product"})
  end

  test "get/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/products/prod_123"
      {:ok, %Req.Response{status: 200, body: %{"id" => "prod_123"}}}
    end)

    assert {:ok, %{"id" => "prod_123"}} = Product.get("prod_123")
  end

  test "search/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/products/search"
      assert req.options[:params] == [query: "foo"]
      {:ok, %Req.Response{status: 200, body: []}}
    end)

    assert {:ok, []} = Product.search(query: "foo")
  end
end
