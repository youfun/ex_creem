defmodule ExCreem.Resources.LicenseTest do
  use ExUnit.Case
  import Mox

  alias ExCreem.Resources.License

  setup :verify_on_exit!

  test "activate/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/licenses/activate"
      assert req.options[:json] == %{key: "LICENSE-KEY"}
      {:ok, %Req.Response{status: 200, body: %{"active" => true}}}
    end)

    assert {:ok, %{"active" => true}} = License.activate(%{key: "LICENSE-KEY"})
  end

  test "deactivate/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/licenses/deactivate"
      assert req.options[:json] == %{key: "LICENSE-KEY"}
      {:ok, %Req.Response{status: 200, body: %{"active" => false}}}
    end)

    assert {:ok, %{"active" => false}} = License.deactivate(%{key: "LICENSE-KEY"})
  end

  test "validate/1" do
    ExCreem.AdapterMock
    |> expect(:request, fn req ->
      assert req.method == :post
      assert req.url.path == "/v1/licenses/validate"
      assert req.options[:json] == %{key: "LICENSE-KEY"}
      {:ok, %Req.Response{status: 200, body: %{"valid" => true}}}
    end)

    assert {:ok, %{"valid" => true}} = License.validate(%{key: "LICENSE-KEY"})
  end
end
