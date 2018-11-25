defmodule SmartHome.CLI do
  # Echo CLI
  use Colossus

  desc("<operation>  <name>", "turns light on/off")
  long_desc """
    Turn ligh on/of
    <operation> - can be one of "on", "off", "toggle", "show"
    <name> - is a name of bulb
    Usage Example:
    light on bulb1
    light show bulb1
    light toggle bulb1
  """
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

  desc "<operation>", "performs operations with laundry"
  desc("<operation>  <name>", "turns light on/off")
  long_desc """
  Turn ligh on/of
  <operation> - can be one of "start", "stop", "status", "watch"
  Usage Example:
  light on bulb1
  light show bulb1
  light toggle bulb1
  """
  def laundry("start") do
    Colossus.live()
    Colossus.puts("Starting laundry...")

    case SmartHome.StateServer.laundry_start() do
      :ok -> Colossus.puts("Laundry was started")
      _ -> Colossus.puts("Laundry was not started. Try again")
    end

    Colossus.commit()
  end

  def laundry("stop") do
    Colossus.live()
    Colossus.puts("Stopping laundry...")

    case SmartHome.StateServer.laundry_stop() do
      :ok -> Colossus.puts("Laundry was stopped")
      _ -> Colossus.puts("Laundry was not stopped. Try again")
    end

    Colossus.commit()
  end

  def laundry("status") do
    case SmartHome.StateServer.laundry_state() do
      {:ok, %{status: status, progress: progress}} -> Colossus.puts("Laundry in #{status}: #{progress}%")
      :error -> Colossus.puts("Unable to show laundry progress.")
    end
  end

  def laundry("watch") do
    Colossus.live()
    do_laundry_watch()
    Colossus.commit()
  end

  defp do_laundry_watch() do
    case SmartHome.StateServer.laundry_state() do
      {:ok, %{progress: 100}} ->
        Colossus.puts("Laundry is finished")
      {:ok, %{status: status, progress: progress}} when status == :stop or status == :idle ->
        Colossus.puts("Laundry in #{status}: #{progress}%")
      {:ok, %{status: status, progress: progress}} ->
        Colossus.puts("Laundry in #{status}: #{progress}%")
        :timer.sleep(200)
        do_laundry_watch()
      :error -> Colossus.puts("Unable to show laundry progress.")
    end
  end

  defp format_bulb_state(true), do: "turned on"
  defp format_bulb_state(false), do: "turned off"
end
