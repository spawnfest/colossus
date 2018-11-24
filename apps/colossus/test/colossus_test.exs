defmodule ColossusTest do
  use ExUnit.Case
  doctest Colossus

  test "greets the world" do
    assert Colossus.hello() == :world
  end
end
