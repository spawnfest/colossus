defmodule ColossusTg.SmartHome do
  use Agala.Provider.Telegram, :handler

  require Logger

  def init(opts), do: opts

  def call(conn = %Agala.Conn{
    request: %{"message" => %{"chat" => %{"id" => chat_id, "type" => "private"}, "text" => text}}
  }, _) do
    ColossusTg.UserServer.Supervisor.dispatch_message(chat_id, text)
    conn
  end

  #################################################

  def call(conn = %Agala.Conn{
    request: request
  }, _) do
    Logger.error("Unexpected message:\n#{inspect request}")
    conn
  end
end
