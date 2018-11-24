defmodule ColossusTg.Chain do
  use Agala.Chain.Builder
  use Agala.Provider.Telegram, :handler

  require Logger

  chain(Agala.Chain.Loopback)
  chain(:handle)

  # Forward private messages into specific chain
  def handle(
        conn = %Agala.Conn{
          request: %{"message" => %{"chat" => %{"type" => "private"}}}
        },
        _
      ) do
    Logger.debug("New request in private chat!")
    ColossusTg.SmartHome.call(conn, [])
  end

  # Wildcard catch
  def handle(
        conn = %Agala.Conn{
          request: request
        },
        _
      ) do
    Logger.error("Unexpected message:\n#{inspect(request)}")
    conn
  end
end
