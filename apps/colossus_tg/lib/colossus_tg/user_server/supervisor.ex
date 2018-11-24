defmodule ColossusTg.UserServer.Supervisor do
  use DynamicSupervisor

  alais ColossusTg.UserServer.Handler

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def dispatch_message(user_id, message) do
    case DynamicSupervisor.start_child(__MODULE__, {ColossusTg.UsersServer.Handler, [user_id]}) do
      {:ok, pid} -> Handler.dispatch(pid, message)

    end
  end
end
