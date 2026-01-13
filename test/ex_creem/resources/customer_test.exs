defmodule ExCreem.Resources.CustomerTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.Customer

  setup :verify_on_exit!

  test "get/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/customers/cust_123"
      {:ok, %Req.Response{status: 200, body: %{"id" => "cust_123"}}}
    end)

    assert {:ok, %{"id" => "cust_123"}} = Customer.get("cust_123")
  end

  test "list/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/customers/list"
      {:ok, %Req.Response{status: 200, body: [%{"id" => "cust_123"}]}}
    end)

    assert {:ok, [%{"id" => "cust_123"}]} = Customer.list()
  end

  test "create_billing_portal/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/customers/billing"
      assert req.options[:json] == %{customer_id: "cust_123"}
      {:ok, %Req.Response{status: 200, body: %{"url" => "https://billing.creem.io/..."}}}
    end)

    assert {:ok, %{"url" => "https://billing.creem.io/..."}} =
             Customer.create_billing_portal(%{customer_id: "cust_123"})
  end
end
