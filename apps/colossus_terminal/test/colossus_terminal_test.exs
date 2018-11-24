defmodule ColossusTerminalTest do
  use ExUnit.Case
  doctest ColossusTerminal

  test "greets the world" do
    assert ColossusTerminal.hello() == :world
  end
end
