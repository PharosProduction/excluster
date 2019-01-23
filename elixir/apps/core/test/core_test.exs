defmodule CoreTest do
  use ExUnit.Case
  doctest Core

  test "greets the world" do
    assert Core.hello() == "Hello from Core test config"
  end
end
