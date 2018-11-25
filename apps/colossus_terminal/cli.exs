defmodule ColossusTerminal.CLI do
  def run_cli() do
    IO.gets("")
    |> SmartHome.CLI.run(ColossusTerminal.Adapter, Colossus.Terminal.OutHandler)
    run_cli()
  end
end


ColossusTerminal.CLI.run_cli()
