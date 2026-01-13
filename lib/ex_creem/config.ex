defmodule ExCreem.Config do
  @moduledoc """
  Handles configuration for ExCreem.
  """

  @default_api_url "https://api.creem.io"
  @test_api_url "https://test-api.creem.io"

  def get do
    Application.get_all_env(:ex_creem)
  end

  def api_key do
    Keyword.get(get(), :api_key) || System.get_env("CREEM_API_KEY")
  end

  def test_mode? do
    Keyword.get(get(), :test_mode, false)
  end

  def base_url do
    if test_mode?() do
      @test_api_url
    else
      @default_api_url
    end
  end
end
