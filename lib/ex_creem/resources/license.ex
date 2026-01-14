defmodule ExCreem.Resources.License do
  @moduledoc """
  License resources.
  """

  alias ExCreem.Client

  def activate(params, opts \\ []) do
    Client.post("/v1/licenses/activate", params, opts)
  end

  def deactivate(params, opts \\ []) do
    Client.post("/v1/licenses/deactivate", params, opts)
  end

  def validate(params, opts \\ []) do
    Client.post("/v1/licenses/validate", params, opts)
  end
end
