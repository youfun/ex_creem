defmodule ExCreem.Resources.Product do
  @moduledoc """
  Product resources.
  """

  alias ExCreem.Client

  def create(params, opts \\ []) do
    Client.post("/v1/products", params, opts)
  end

  def get(id, opts \\ []) do
    Client.get("/v1/products/#{id}", [], opts)
  end

  def search(params \\ [], opts \\ []) do
    Client.get("/v1/products/search", params, opts)
  end
end
