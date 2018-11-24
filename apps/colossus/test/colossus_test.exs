defmodule ColossusTest do
  use ExUnit.Case
  doctest Colossus

  test "list help" do
    assert [concat: nil, install: "Install something", list: "List things"] ==
             Colossus.TestApp.help()
  end

  test "help command for command options desc" do
    assert {:install, "Install something",
            [{:sudo, nil}, {:path, "Installiation path"}, {:test, "hey"}]} ==
             Colossus.TestApp.help("install")
  end

  test "run with options" do
    assert "installing test to path /dev" ==
             Colossus.TestApp.run(["install", "test"], %{path: "/dev"})
  end

  test "run without arguments" do
    assert "listing" == Colossus.TestApp.run("listing")
  end

  test "run with multiple arguments" do
    assert ["a", "b", "c"] = Colossus.TestApp.run(["concat", "a", "b", "c"])
  end

  test "run help" do
    IO.inspect Colossus.TestApp.run([])
  end
end
