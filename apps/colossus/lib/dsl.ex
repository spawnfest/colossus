defmodule Colossus.DSL do
  alias Colossus.Options

  def __on_definition__(env, :def, name, _args, _guards, _body) do
    desc = Module.get_attribute(env.module, :desc)
    options = Module.get_attribute(env.module, :option)

    Module.put_attribute(env.module, :actions, {name, %{description: desc, options: options}})

    Module.delete_attribute(env.module, :desc)
    Module.delete_attribute(env.module, :option)
  end

  def __on_definition__(_, _, _, _, _, _) do
  end

  defmacro desc(text) do
    quote do
      @desc unquote(text)
    end
  end

  defmacro option(key, config \\ []) do
    quote do
      @option {unquote(key), unquote(config)}
    end
  end

  defmacro module_option(key, config \\ []) do
    quote do
      @module_option {unquote(key), unquote(config)}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run([]) do
        help
      end

      def run(message, parser, output) do
        args =
          message # "install test --path /dev/sda"
          |> parser.parse
          |> IO.inspect

        apply(&execute/2, args)
        |> parser.encode
        # |> Colossus.puts(parser)
      end


      def help do
        for {action, %{description: desc}} <-
        Enum.reject(@actions, fn {name, _} -> name == :run || name == :help end) do
          {action, desc}
        end
      end

      def help(action_key) do
        key = String.to_existing_atom(action_key)
        action = Keyword.get(@actions, key)

        options_desc =
          Enum.map(action.options ++ @module_option, fn opt ->
            case opt do
              {key, config} ->
                {key, Keyword.get(config, :description)}

              {key} ->
                {key}
            end
          end)

        {key, action.description, options_desc}
      end

      def execute([action | args], options \\ %{}) do
        case Keyword.get(@actions, String.to_atom(action)) do
          %{options: []} ->
            apply(__MODULE__, String.to_atom(action), args)

          %{options: function_options} ->
            options = Colossus.Options.handle_options(function_options, options, @module_option)
            apply(__MODULE__, String.to_atom(action), [args | [options]])
        end
      end

    end
  end
end
