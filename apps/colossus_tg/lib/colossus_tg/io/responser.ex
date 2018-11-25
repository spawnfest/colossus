defmodule ColossusTg.Responser do
  use Agala.Provider.Telegram, :handler
  def handle(_user_id, :begin) do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :live ->
        raise RuntimeError,
              "You can't start complex message with `begin` during live update. Commit it firstly."

      _ ->
        Process.put(Colossus.Terminal.OutHandler.Status, :begin)
        :ok
    end
  end

  def handle(_user_id, :live) do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :begin ->
        raise RuntimeError,
              "You can't start live message with `live` during comlex message building. Commit it firstly."

      _ ->
        Process.put(Colossus.Terminal.OutHandler.Status, :live)
        :ok
    end
  end

  def handle(user_id, :commit) do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :begin ->
        Process.get(Colossus.Terminal.OutHandler.Data)
        |> Enum.join("\n")
        |> telegram_output(user_id)

        Process.put(Colossus.Terminal.OutHandler.Status, nil)
        Process.put(Colossus.Terminal.OutHandler.Data, nil)
        :ok

      :live ->
        Process.get(Colossus.Terminal.OutHandler.Data)
        |> telegram_output(user_id)

        Process.put(Colossus.Terminal.OutHandler.Status, nil)
        Process.put(Colossus.Terminal.OutHandler.Data, nil)
        :ok

      nil ->
        :ok
    end
  end

  def handle(user_id, {:puts, message}) do
    case Process.get(Colossus.Terminal.OutHandler.Status) do
      :begin ->
        Process.put(
          Colossus.Terminal.OutHandler.Data,
          [message | Process.get(Colossus.Terminal.OutHandler.Data, [])]
        )

        :ok

      :live ->
        Process.put(Colossus.Terminal.OutHandler.Data, message)
        :ok

      _ ->
        telegram_output(message, user_id)
        :ok
    end
  end

  defp telegram_output(message, user_id) do
    %Agala.Conn{}
    |> Agala.Conn.send_to(ColossusTg.Bot)
    |> send_message(user_id, message)
  end
end
