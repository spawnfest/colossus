defmodule ColossusTerminal.CLI do
  def run_cli() do
    IO.gets("")
    |> ColossusTerminal.TestApp.run(ColossusTerminal.Adapter, &IO.write/1)
    # |> IO.write()
    # IO.inspect(SmartHome.StateServer.__get_state())
    run_cli()
  end
end


ColossusTerminal.CLI.run_cli()
