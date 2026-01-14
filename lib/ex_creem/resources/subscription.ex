defmodule ExCreem.Resources.Subscription do
  @moduledoc """
  Subscription resources.
  """

  alias ExCreem.Client

  def get(id, opts \\ []) do
    Client.get("/v1/subscriptions/#{id}", [], opts)
  end

  def update(id, params, opts \\ []) do
    Client.post("/v1/subscriptions/#{id}", params, opts)
  end

  def cancel(id, opts \\ []) do
    Client.post("/v1/subscriptions/#{id}/cancel", %{}, opts)
  end

  def upgrade(id, params, opts \\ []) do
    Client.post("/v1/subscriptions/#{id}/upgrade", params, opts)
  end
end
