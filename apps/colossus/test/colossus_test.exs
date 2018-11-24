defmodule ColossusTest do
  use ExUnit.Case
  doctest Colossus

  test "list help" do
    assert [install: "Install something", list: "List things"] == Colossus.TestApp.help
  end
end
