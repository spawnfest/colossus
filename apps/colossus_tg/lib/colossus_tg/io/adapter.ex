defmodule ColossusTg.Adapter do
  @behaviour Colossus.Encoder

  def parse(message) do
    message
    |> String.trim_leading("/")
    |> String.trim("\n")
  end

  def encode(values) do
    "/" <> (values |> to_string)
  end
end
