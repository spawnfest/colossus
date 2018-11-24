defmodule SmartHomeTest do
  use ExUnit.Case
  doctest SmartHome

  test "greets the world" do
    assert SmartHome.hello() == :world
  end
end
