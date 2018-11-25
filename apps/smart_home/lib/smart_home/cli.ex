defmodule SmartHome.CLI do
  # Echo CLI
  use Colossus

  desc "turns light on/off"
  def light("on", name) do
    Colossus.Terminal.OutHandler.puts("Turingin on: #{name}")
  end

  defp missing_action(message) do
    Colossus.Terminal.OutHandler.puts("there is no such a thing")
  end
end
