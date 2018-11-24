defmodule AdapterTest do
  use ExUnit.Case

  describe "parse" do
    test "with options" do
      line = "Yehuda herua --from 'Carl Lerche' \n"
      IO.inspect ColossusTerminal.Adapter.parse(line)
    end
  end
end
