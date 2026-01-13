defmodule ExCreem.Resources.TransactionTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.Transaction

  setup :verify_on_exit!

  test "search/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/transactions/search"
      assert req.options[:params] == [customer_id: "cust_123"]
      {:ok, %Req.Response{status: 200, body: []}}
    end)

    assert {:ok, []} = Transaction.search(customer_id: "cust_123")
  end
end
