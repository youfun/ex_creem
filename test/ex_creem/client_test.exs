defmodule ExCreem.ClientTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Client

  # Verify mocking works
  test "post/2 sends correct request" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.options[:base_url] == "https://api.creem.io"
      assert req.url.path == "/test-path"
      # Check for API key header
      assert ["test_api_key"] == Req.Request.get_header(req, "x-api-key")

      {:ok, %Req.Response{status: 200, body: %{"success" => true}}}
    end)

    assert {:ok, %{"success" => true}} = Client.post("/test-path", %{foo: "bar"})
  end

  test "get/3 sends correct request with params" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :get
      assert req.url.path == "/test-path"
      assert req.options[:params] == [q: "search"]

      {:ok, %Req.Response{status: 200, body: %{"data" => []}}}
    end)

    assert {:ok, %{"data" => []}} = Client.get("/test-path", q: "search")
  end
end
