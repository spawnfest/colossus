defmodule Colossus.OutHandler do
  @callback begin() :: :ok
  @callback commit() :: :ok
  @callback live() :: :ok
  @callback puts(data :: any()) :: :ok

  defmacro __using__(_opts) do
    quote do
      @behaviour Colossus.OutHandler
    end
  end
end
