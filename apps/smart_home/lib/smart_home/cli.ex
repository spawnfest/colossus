defmodule SmartHome.CLI do
  # Echo CLI
  use Colossus
  alias Colossus.Terminal.OutHandler

  desc "turns light on/off"
  def light("on", name) do
    OutHandler.live()
    OutHandler.puts("Turingin on: #{name}")
    case SmartHome.StateServer.switch_on(name) do
      :ok -> OutHandler.puts("#{name} was turned on!")
      :error -> OutHandler.puts("#{name} was not found!")
    end
    OutHandler.commit()
  end

  def light("off", name) do
    OutHandler.live()
    OutHandler.puts("Turingin off: #{name}")
    case SmartHome.StateServer.switch_off(name) do
      :ok -> OutHandler.puts("#{name} was turned off!")
      :error -> OutHandler.puts("#{name} was not found!")
    end
    OutHandler.commit()
  end

  def light("toggle", name) do
    OutHandler.live()
    OutHandler.puts("Toggling: #{name}")
    case SmartHome.StateServer.switch_toggle(name) do
      :ok -> OutHandler.puts("#{name} was toggled!")
      :error -> OutHandler.puts("#{name} was not found!")
    end
    OutHandler.commit()
  end

  def light("show", name) do
    case SmartHome.StateServer.switch_state(name) do
      {:ok, value} -> OutHandler.puts("State of #{name}: #{format_bulb_state(value)}")
      :error -> OutHandler.puts("No such device")
    end
  end

  defp format_bulb_state(true), do: "turned on"
  defp format_bulb_state(false), do: "turned off"
end
