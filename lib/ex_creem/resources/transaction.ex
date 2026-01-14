defmodule ExCreem.Resources.Transaction do
  @moduledoc """
  Transaction resources.
  """

  alias ExCreem.Client

  def search(params \\ [], opts \\ []) do
    Client.get("/v1/transactions/search", params, opts)
  end
end
