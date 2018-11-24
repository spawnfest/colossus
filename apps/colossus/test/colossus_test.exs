defmodule ColossusTest do
  use ExUnit.Case
  doctest Colossus

  test "list help" do
    assert [install: "Install something", list: "List things"] == Colossus.TestApp.help
  end

  test "help command for command options desc" do
    assert {:install, "Install something", [{:sudo}, {:path, "Installiation path"}]} == Colossus.TestApp.help("install")
  end

  test "run" do
    assert "installing test to path /dev" == Colossus.TestApp.run(["install", "test"], %{ path: "/dev" })
  end
end
