defmodule Colossus.DSL do
  alias Colossus.Options

  def __on_definition__(env, :def, name, args, _guards, _body) do
    desc = Module.get_attribute(env.module, :desc)
    options = Module.get_attribute(env.module, :option)

    Module.put_attribute(
      env.module,
      :actions,
      {name, %{description: desc, options: options, arity: elem(env.function, 1)}}
    )

    Module.delete_attribute(env.module, :desc)
    Module.delete_attribute(env.module, :option)
  end

  def __on_definition__(_, _, _, _, _, _) do
  end

  @doc "Describes action"
  defmacro desc(text) do
    quote do
      @desc unquote(text)
    end
  end

  @doc "Specify options for action"
  defmacro option(key, config \\ []) do
    quote do
      @option {unquote(key), unquote(config)}
    end
  end

  @doc "Global options for all action in module"
  defmacro module_option(key, config \\ []) do
    quote do
      @module_option {unquote(key), unquote(config)}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run([]) do
        puts(help)
      end

      def run(message, adapter, output \\ nil) do
        Process.put(Colossus.IO, output)

        args =
          message
          |> adapter.parse
          |> OptionParser.split()

        case args do
          [action_name | opts] ->
            if is_action_present?(action_name) do
              aliases = get_action_config(action_name).options |> get_aliases
              Process.put(Colossus.IO, output)

              try do
                apply(&execute/2, create_cmd(args, aliases))
              rescue
                UndefinedFunctionError ->
                  help(action_name)
                FunctionClauseError ->
                  help(action_name)
              end
            else
              missing_action(action_name)
            end

          _ ->
            missing_action(message)
        end
      end

      def help do
        not_propiretary_actions
        |> compress_commands_for_help
        |> @help_encoder.()
        |> puts
      end

      def help(action_key) do
        key = String.to_existing_atom(action_key)
        action =
          not_propiretary_actions
          |> compress_commands_for_help
          |> Keyword.get(key)

        options_desc =
          Enum.map(action.options ++ @module_option, fn opt ->
            case opt do
              {key, config} ->
                {key, Keyword.get(config, :description)}

              {key} ->
                {key}
            end
          end)

        puts(@help_command_encoder.({key, action.description, options_desc}))
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

      defp not_propiretary_actions do
        propiretary_functions = [:run, :help, :execute, :missing_action]
        Enum.reject(@actions, fn {name, _} -> Enum.member?(propiretary_functions, name) end)
      end

      defp get_action_config(action) do
        Keyword.get(@actions, String.to_existing_atom(action))
      end

      defp get_aliases(func_options) do
        Enum.map(func_options, fn {k, v} ->
          {Keyword.get(v, :alias), k}
        end)
        |> Enum.filter(&elem(&1, 1))
      end

      defp is_action_present?(action_name) do
        @actions
        |> Keyword.keys()
        |> Enum.map(&to_string/1)
        |> List.insert_at(0, "help")
        |> Enum.member?(action_name)
      end

      defp create_cmd(args, aliases) do
        args
        |> OptionParser.parse!(aliases: aliases, switches: [])
        |> Tuple.to_list()
        |> Enum.reverse()
        |> List.update_at(1, &Enum.into(&1, %{}))
      end

      defp compress_commands_for_help(commands) do
        commands
        |> Enum.uniq()
        |> Enum.filter(fn {key, config} ->
          Enum.find(commands, fn {k, v} ->
            k == key && config.description && config.arity == v.arity && is_nil(v.description)
          end)
        end)
      end

      defp missing_action(message) do
        puts("""
         There is no such command #{message}
         Please check list of available commands
        """)

        help
      end
    end
  end
end
