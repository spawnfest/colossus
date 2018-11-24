defmodule ColossusTg.UserServer.Handler do
  use Agala.Provider.Telegram, :handler
  use GenServer

  def via_tuple(user_id) do
    {:via, Registry, {ColossusTg.UserRegistry, user_id}}
  end

  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: via_tuple(user_id))
  end

  def init(user_id) do
    {:ok, user_id}
  end

  def dispatch(user_id, message) do
    IO.inspect("Dispatch in Handler is hit")
    GenServer.cast(via_tuple(user_id), {:dispatch, message})
  end

  def handle_cast({:dispatch, message}, state) do
    IO.inspect("Dispatch in handle_cast in Handler is hit")
    SmartHome.CLI.run(
      message,
      :formatter,
      &telegram_output(state, &1)
      )

      {:noreply, state}
  end

  def telegram_output(user_id, {:puts, message}) do
    %Agala.Conn{}
    |> Agala.Conn.send_to(ColossusTg.Bot)
    |> send_message(user_id, message)
  end

end


# def handle_cast({:dispatch, message}, _from, state) do
#   MyCli.run(
#     message, # "hello 'Name' --keks Shmeks" "/hello 'Name' --keks Shmeks"
#     input_parser,  # %{command: ['name', 'sdf'], options: %{keks: "Shmeks"}}
#     # &(Process.send(pid, &1)),
#     # &IO.puts(&1)
#     # pid | module | callback_function()


#     # fn {:puts, message} -> IO.puts(message) end
#   )
# end

# defmodule CallbackModule do
#   :begin
#   :commit
#   :puts message
#   :begin_life_update
#   :end_life_update
# end

# defmodule do
#   def handle_begin() do

#   end
#   :ets
# end
