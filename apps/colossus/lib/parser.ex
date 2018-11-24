defmodule Colossus.IOAdapter do
  @callback parse(String.t) :: [{list(String.t), map}] | no_return
  @callback encode(any) :: {:ok, String.t} 


  def encode_to_command(string, aliases) do
    string
    |> OptionParser.split
    |> OptionParser.parse!()
  end
end
