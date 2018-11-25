defmodule ColossusTerminal.Adapter do
  @behaviour Colossus.Encoder

  def parse(message) do
    message
    |> String.trim("\n")
  end

  def encode(values) do
    values |> to_string
  end
end
