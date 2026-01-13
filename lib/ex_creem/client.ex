defmodule ExCreem.Client do
  @moduledoc """
  HTTP Client for Creem API.
  """

  alias ExCreem.Config

  def new(opts \\ []) do
    api_key = opts[:api_key] || Config.api_key()
    base_url = opts[:base_url] || Config.base_url()

    Req.new(base_url: base_url)
    |> Req.Request.put_header("x-api-key", api_key)
    |> Req.Request.put_header("content-type", "application/json")
  end

  def post(path, body, opts \\ []) do
    execute(:post, path, body, opts)
  end

  def get(path, params \\ [], opts \\ []) do
    execute(:get, path, nil, Keyword.put(opts, :params, params))
  end

  def delete(path, opts \\ []) do
    execute(:delete, path, nil, opts)
  end

  defp execute(method, path, body, opts) do
    client = new(opts)

    options =
      if body do
        [json: body]
      else
        []
      end
      |> Keyword.merge(opts)

    req = Req.merge(client, [{:method, method}, {:url, path} | options])

    case adapter().request(req) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:error, {status, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp adapter do
    Application.get_env(:ex_creem, :adapter, ExCreem.Adapter.Req)
  end
end
