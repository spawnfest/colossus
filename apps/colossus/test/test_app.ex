defmodule Colossus.TestApp do
  use Colossus

  desc("List things")
  def list do
    IO.puts("listing")
  end

  desc("Install something")
  option(:path, required: true, description: "Installiation path")
  option(:sudo)
  def install(name, %{path: path}) do
    "installing #{name} to path #{path}"
  end
end
