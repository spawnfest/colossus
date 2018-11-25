defmodule ColossusTg.UserServer.Handler do
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
      ColossusTg.Adapter,
      &ColossusTg.Responser.handle(state, &1)
    )

    {:noreply, state}
  end
end
