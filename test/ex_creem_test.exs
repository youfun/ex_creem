defmodule ExCreemTest do
  use ExUnit.Case
  doctest ExCreem

  test "greets the world" do
    assert ExCreem.hello() == :world
  end
end
