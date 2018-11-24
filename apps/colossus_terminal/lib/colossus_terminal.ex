defmodule ColossusTerminal do
  @doc """
  Main function
  """
  def start(_, _) do
    {:ok, spawn(&run_cli/0)}
  end

  def run_cli() do
    input = IO.gets("")
    IO.puts(input)
    run_cli()
  end
end
