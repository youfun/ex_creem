defmodule ExCreem.Adapter do
  @moduledoc """
  Behaviour for HTTP adapter.
  """
  @callback request(Req.Request.t()) :: {:ok, Req.Response.t()} | {:error, any()}
end

defmodule ExCreem.Adapter.Req do
  @moduledoc """
  Default HTTP adapter using Req.
  """
  @behaviour ExCreem.Adapter

  def request(req) do
    Req.request(req)
  end
end
