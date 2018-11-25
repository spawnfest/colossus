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
        Colossus.IO.puts(help)
      end

      def run(message, adapter, output \\ nil) do
        Process.put(Colossus.IO, output)

        [action_name | opts] =
          args =
          message
          |> adapter.parse
          |> OptionParser.split()

        is_action_present =
          @actions
          |> Keyword.keys()
          |> Enum.map(&to_string/1)
          |> Enum.member?(action_name)

        if is_action_present || action_name == "help" do
          aliases = get_action_config(action_name).options |> get_aliases

          cmd =
            args
            |> OptionParser.parse!(aliases: aliases, switches: [])
            |> Tuple.to_list()
            |> Enum.reverse()
            |> List.update_at(1, &Enum.into(&1, %{}))

          Process.put(Colossus.IO, output)
          apply(&execute/2, cmd)
        else
          @missing_action.(action_name)
        end
      end

      def help do
        commands =
          for {action, %{description: desc}} <- not_propiretary_actions do
            {action, desc}
          end

        Colossus.IO.puts(@help_encoder.(commands))
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

        Colossus.IO.puts(@help_command_encoder.({key, action.description, options_desc}))
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
        propiretary_functions = [:run, :help, :execute]
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
    end
  end

  def missing_action(action_name) do
    ""
  end
end
