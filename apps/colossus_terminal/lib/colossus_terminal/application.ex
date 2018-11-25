defmodule ColossusTerminal.Application do
  use Application

  @doc """
  This function will start our application during loading process for the cli script.
  We need to start Home's state server, in order to control it with our CLI
  """
  def start(_type, _args) do
    children = [
      {SmartHome.StateServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ColossusTerminal.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
