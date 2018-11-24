defmodule Colossus.IOAdapter do
  @callback parse(String.t) :: [{list(String.t), map}] | no_return
  @callback encode(any) :: {:ok, String.t} 
end
