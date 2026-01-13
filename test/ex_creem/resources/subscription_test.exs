defmodule ExCreem.Resources.SubscriptionTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.Subscription

  setup :verify_on_exit!

  test "get/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/v1/subscriptions/sub_123"
      {:ok, %Req.Response{status: 200, body: %{"id" => "sub_123"}}}
    end)

    assert {:ok, %{"id" => "sub_123"}} = Subscription.get("sub_123")
  end

  test "update/2" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/subscriptions/sub_123"
      assert req.options[:json] == %{status: "active"}
      {:ok, %Req.Response{status: 200, body: %{"id" => "sub_123"}}}
    end)

    assert {:ok, %{"id" => "sub_123"}} = Subscription.update("sub_123", %{status: "active"})
  end

  test "cancel/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/subscriptions/sub_123/cancel"
      {:ok, %Req.Response{status: 200, body: %{"status" => "canceled"}}}
    end)

    assert {:ok, %{"status" => "canceled"}} = Subscription.cancel("sub_123")
  end

  test "upgrade/2" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/subscriptions/sub_123/upgrade"
      assert req.options[:json] == %{plan: "pro"}
      {:ok, %Req.Response{status: 200, body: %{"plan" => "pro"}}}
    end)

    assert {:ok, %{"plan" => "pro"}} = Subscription.upgrade("sub_123", %{plan: "pro"})
  end
end
