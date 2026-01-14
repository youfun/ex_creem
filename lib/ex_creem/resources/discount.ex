defmodule ExCreem.Resources.Discount do
  @moduledoc """
  Discount resources.
  """

  alias ExCreem.Client

  def create(params, opts \\ []) do
    Client.post("/v1/discounts", params, opts)
  end

  def get(id, opts \\ []) do
    # Assuming /v1/discounts/{id} or /v1/discounts?code=...
    # The doc says "Retrieve discount code details by ID or code."
    # If ID, likely path param. If code, maybe query param?
    # SDK example: creem.discounts.get({ discountId: '...' })
    Client.get("/v1/discounts/#{id}", [], opts)
  end

  def delete(id, opts \\ []) do
    Client.delete("/v1/discounts/#{id}/delete", opts)
  end
end
