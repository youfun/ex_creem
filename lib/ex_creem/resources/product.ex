defmodule ExCreem.Resources.Product do
  @moduledoc """
  Product resources.
  """

  alias ExCreem.Client

  def create(params) do
    Client.post("/v1/products", params)
  end

  def get(id) do
    Client.get("/v1/products/#{id}")
  end

  def search(params \\ []) do
    Client.get("/v1/products/search", params)
  end
end
