defmodule Colossus.TestApp do
  use Colossus

  desc("List things")
  option(:from1, required: true)
  def list do
    IO.puts("listing")
  end

  desc("Install something")
  option(:from2, required: true)

  def install(name, opts) do
    IO.puts("installing #{name}")
  end
end
