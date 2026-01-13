defmodule ExCreem.Resources.DiscountTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.Discount

  setup :verify_on_exit!

  test "create/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/discounts"
      assert req.options[:json] == %{code: "SAVE10"}
      {:ok, %Req.Response{status: 201, body: %{"id" => "disc_123"}}}
    end)

    assert {:ok, %{"id" => "disc_123"}} = Discount.create(%{code: "SAVE10"})
  end

  test "get/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/discounts/disc_123"
      {:ok, %Req.Response{status: 200, body: %{"id" => "disc_123"}}}
    end)

    assert {:ok, %{"id" => "disc_123"}} = Discount.get("disc_123")
  end

  test "delete/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :delete
      assert req.url.path == "/v1/discounts/disc_123/delete"
      {:ok, %Req.Response{status: 200, body: %{"deleted" => true}}}
    end)

    assert {:ok, %{"deleted" => true}} = Discount.delete("disc_123")
  end
end
