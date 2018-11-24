defmodule SmartHome.CLI do
  # Echo CLI
  def run(message, _parser, response_callback) do
    IO.inspect("CLI run is hit")
    response_callback.({:puts, message})
  end
end
