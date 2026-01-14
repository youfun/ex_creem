defmodule ExCreem.Resources.Checkout do
  @moduledoc """
  Checkout resources.
  """

  alias ExCreem.Client

  def create(params, opts \\ []) do
    Client.post("/v1/checkouts", params, opts)
  end

  def get(id, opts \\ []) do
    # Assuming RESTful standard /v1/checkouts/{id}
    # If the docs mean /v1/checkouts?id=..., we might need to change this.
    # But "by ID" usually implies path param in modern APIs.
    Client.get("/v1/checkouts/#{id}", [], opts)
  end
end
