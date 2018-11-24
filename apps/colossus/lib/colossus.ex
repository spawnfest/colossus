defmodule Colossus do
  defmacro __using__(_opts) do
    quote do
      import Colossus.DSL

      Module.register_attribute(__MODULE__, :desc, [])
      Module.register_attribute(__MODULE__, :option, accumulate: true)
      Module.register_attribute(__MODULE__, :actions, accumulate: true)

      @on_definition Colossus.DSL
      @before_compile Colossus.DSL
    end
  end
end
