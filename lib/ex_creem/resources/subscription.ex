defmodule ExCreem.Resources.Subscription do
  @moduledoc """
  Subscription resources.
  """

  alias ExCreem.Client

  def get(id) do
    Client.get("/v1/subscriptions/#{id}")
  end

  def update(id, params) do
    Client.post("/v1/subscriptions/#{id}", params)
  end

  def cancel(id) do
    Client.post("/v1/subscriptions/#{id}/cancel", %{})
  end

  def upgrade(id, params) do
    Client.post("/v1/subscriptions/#{id}/upgrade", params)
  end
end
