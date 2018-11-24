defmodule SmartHome.CLI do
  # Echo CLI
  use Colossus

  def light("on", name) do
    IO.inspect("Turingin on: #{name}")
  end
end
