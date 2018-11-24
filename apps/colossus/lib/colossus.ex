defmodule Colossus do
  defmacro __using__(_opts) do
    quote do
      import Colossus.DSL

      @on_definition Colossus.DSL
      @before_compile Colossus.DSL
    end
  end
end
