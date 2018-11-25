defmodule Colossus.Terminal.OutHandler do
  use Colossus.OutHandler

  def begin() do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :live ->
        raise RuntimeError,
              "You can't start complex message with `begin` during live update. Commit it firstly."

      _ ->
        Process.put(Colossus.Terminal.OutHandler.Status, :begin)
        :ok
    end
  end

  def live() do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :begin ->
        raise RuntimeError,
              "You can't start live message with `live` during comlex message building. Commit it firstly."

      _ ->
        Process.put(Colossus.Terminal.OutHandler.Status, :live)
        :ok
    end
  end

  def commit() do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :begin ->
        Process.get(Colossus.Terminal.OutHandler.Data)
        |> Enum.join("\n")
        |> IO.puts()

        Process.put(Colossus.Terminal.OutHandler.Status, nil)
        Process.put(Colossus.Terminal.OutHandler.Data, nil)
        :ok

      :live ->
        Process.put(Colossus.Terminal.OutHandler.Status, nil)
        IO.write("\n")
        :ok

      nil ->
        :ok
    end
  end

  def puts(message) do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :begin ->
        Process.put(
          Colossus.Terminal.OutHandler.Data,
          [message | Process.get(Colossus.Terminal.OutHandler.Data, [])]
        )

        :ok

      :live ->
        "\r#{message}"
        # |> String.pad_trailing(elem(:io.columns(), 1)) // io.columns do not work here for some reason
        |> String.pad_trailing(20)
        |> IO.write()

        :ok

      _ ->
        IO.puts(message)
        :ok
    end
  end
end
