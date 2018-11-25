defmodule SmartHome.CLI do
  # Echo CLI
  use Colossus

  desc "operations with light bulbs"
  def light(operation, name)

  def light("on", name) do
    Colossus.live()
    Colossus.puts("Turingin on: #{name}")
    case SmartHome.StateServer.switch_on(name) do
      :ok -> Colossus.puts("#{name} was turned on!")
      :error -> Colossus.puts("#{name} was not found!")
    end
    Colossus.commit()
  end

  def light("off", name) do
    Colossus.live()
    Colossus.puts("Turingin off: #{name}")
    case SmartHome.StateServer.switch_off(name) do
      :ok -> Colossus.puts("#{name} was turned off!")
      :error -> Colossus.puts("#{name} was not found!")
    end
    Colossus.commit()
  end

  def light("toggle", name) do
    Colossus.live()
    Colossus.puts("Toggling: #{name}")
    case SmartHome.StateServer.switch_toggle(name) do
      :ok -> Colossus.puts("#{name} was toggled!")
      :error -> Colossus.puts("#{name} was not found!")
    end
    Colossus.commit()
  end

  def light("show", name) do
    case SmartHome.StateServer.switch_state(name) do
      {:ok, value} -> Colossus.puts("State of #{name}: #{format_bulb_state(value)}")
      :error -> Colossus.puts("No such device")
    end
  end

  defp format_bulb_state(true), do: "turned on"
  defp format_bulb_state(false), do: "turned off"
end
