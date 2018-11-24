defmodule ColossusTerminal.Adapter do
  @behaviour Colossus.IOAdapter

  def parse(message) do
    message
    |> String.trim("\n")
    |> OptionParser.split()
    |> OptionParser.parse
    |> Tuple.to_list
    |> Enum.reverse
    |> List.delete_at(0)
    |> List.update_at(1, & Enum.into(&1, %{}))
  end

  def encode(values) do
    values |> to_string
  end
end
