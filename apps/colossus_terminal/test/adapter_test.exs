defmodule AdapterTest do
  use ExUnit.Case

  describe "parse" do
    test "with options" do
      # line = "Yehuda herua --from 'Carl Lerche' \n"
      line = "foo bar bazz --arg 'Arg1' -v"
      IO.inspect(ColossusTerminal.Adapter.parse(line))
    end
  end
end
