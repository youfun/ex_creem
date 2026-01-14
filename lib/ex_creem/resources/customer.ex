defmodule ExCreem.Resources.Customer do
  @moduledoc """
  Customer resources.
  """

  alias ExCreem.Client

  def get(id, opts \\ []) do
    Client.get("/v1/customers/#{id}", [], opts)
  end

  def list(params \\ [], opts \\ []) do
    Client.get("/v1/customers/list", params, opts)
  end

  def create_billing_portal(params, opts \\ []) do
    Client.post("/v1/customers/billing", params, opts)
  end
end
