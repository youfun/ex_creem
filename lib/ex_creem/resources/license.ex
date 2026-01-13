defmodule ExCreem.Resources.License do
  @moduledoc """
  License resources.
  """

  alias ExCreem.Client

  def activate(params) do
    Client.post("/v1/licenses/activate", params)
  end

  def deactivate(params) do
    Client.post("/v1/licenses/deactivate", params)
  end

  def validate(params) do
    Client.post("/v1/licenses/validate", params)
  end
end
