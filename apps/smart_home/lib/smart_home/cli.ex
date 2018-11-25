defmodule SmartHome.CLI do
  # Echo CLI
  use Colossus

  desc "turns light on/off"
  def light("on", name) do
    Colossus.Terminal.OutHandler.puts("Turingin on: #{name}")
  end
end
