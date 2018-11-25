defmodule Colossus do
  use Colossus.IO

  defmacro __using__(opts \\ []) do
    quote do
      import Colossus.DSL
      import Colossus.Encoder
      Module.register_attribute(__MODULE__, :desc, [])
      Module.register_attribute(__MODULE__, :option, accumulate: true)
      Module.register_attribute(__MODULE__, :module_option, accumulate: true)
      Module.register_attribute(__MODULE__, :actions, accumulate: true)

      @on_definition Colossus.DSL
      @before_compile Colossus.DSL

      @help_encoder unquote(Keyword.get(opts, :help_encoder, &Colossus.Encoder.default_encode_help_to_eex/1))
      @help_command_encoder unquote(Keyword.get(opts, :help_command_encoder, &Colossus.Encoder.default_encode_help_command_to_eex/1))
    end
  end
end
