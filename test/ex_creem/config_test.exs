defmodule ExCreem.ConfigTest do
  use ExUnit.Case

  alias ExCreem.Config

  # We need to be careful with global state (Application env and System env)
  # running async: false is safer if we modify these.
  # However, for simplicity and safety against race conditions with other tests,
  # we will inspect the current state which is set in test_helper.exs

  test "api_key/0 returns key from application env" do
    # This is set in test_helper.exs
    assert Config.api_key() == "test_api_key"
  end

  test "base_url/0 returns default url by default" do
    # Default is false for test_mode
    assert Config.base_url() == "https://api.creem.io"
  end

  test "base_url/0 returns test url when test_mode is true" do
    original_val = Application.get_env(:ex_creem, :test_mode)
    Application.put_env(:ex_creem, :test_mode, true)

    try do
      assert Config.base_url() == "https://test-api.creem.io"
    after
      if original_val do
        Application.put_env(:ex_creem, :test_mode, original_val)
      else
        Application.delete_env(:ex_creem, :test_mode)
      end
    end
  end
end
