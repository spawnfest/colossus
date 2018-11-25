defmodule ColossusTerminal.CLI do
  def run_cli() do
    IO.gets("")
    |> SmartHome.CLI.run(ColossusTerminal.Adapter, &(IO.write(elem(&1, 1))))
    run_cli()
  end
end


ColossusTerminal.CLI.run_cli()
