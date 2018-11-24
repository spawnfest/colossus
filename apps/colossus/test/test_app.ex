defmodule Colossus.TestApp do
  use Colossus

  desc("List things")
  def list do
    "listing"
  end

  desc("Install something")
  option(:path, required: true, description: "Installiation path")
  option(:sudo)
  def install(name, %{path: path}) do
    "installing #{name} to path #{path}"
  end
  
  def concat(a,b,c) do
    [a,b,c]
  end
end
