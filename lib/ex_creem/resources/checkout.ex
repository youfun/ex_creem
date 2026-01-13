defmodule ExCreem.Resources.Checkout do
  @moduledoc """
  Checkout resources.
  """

  alias ExCreem.Client

  def create(params) do
    Client.post("/v1/checkouts", params)
  end

  def get(id) do
    # Assuming RESTful standard /v1/checkouts/{id}
    # If the docs mean /v1/checkouts?id=..., we might need to change this.
    # But "by ID" usually implies path param in modern APIs.
    Client.get("/v1/checkouts/#{id}")
  end
end
