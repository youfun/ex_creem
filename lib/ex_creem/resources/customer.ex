defmodule ExCreem.Resources.Customer do
  @moduledoc """
  Customer resources.
  """

  alias ExCreem.Client

  def get(id) do
    Client.get("/v1/customers/#{id}")
  end

  def list(params \\ []) do
    Client.get("/v1/customers/list", params)
  end

  def create_billing_portal(params) do
    Client.post("/v1/customers/billing", params)
  end
end
