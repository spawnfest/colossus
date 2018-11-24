defmodule Colossus.TestApp do
  use Colossus

  desc("List things")
  def list do
    IO.puts("listing")
  end

  desc("Install something")
  option(:path, required: true, description: "Installiation path")
  option(:sudo)
  def install(name, opts) do
    IO.puts("installing #{name}")
  end
end
