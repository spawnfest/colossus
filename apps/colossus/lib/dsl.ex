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

  defmacro option(key, opts) do
    quote do
      @option {unquote(key), unquote(opts)}
    end
  end

  defmacro option(key) do
    quote do
      @option {unquote(key)}
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run([]) do
        help
      end

      def run([action | args], options) do
        case Keyword.get(@actions, String.to_atom(action)) do
          %{options: []} ->
            apply(__MODULE__, String.to_atom(action), args)

          %{options: function_options} ->
            options = Colossus.Options.handle_options(function_options, options)
            apply(__MODULE__, String.to_atom(action), [args | [options]])
        end
      end

      def run([action | args]) do
        case Keyword.get(@actions, String.to_atom(action)) do
          %{options: []} ->
            apply(__MODULE__, String.to_atom(action), args)

          %{options: function_options} ->
            options = Colossus.Options.handle_options(function_options, %{})
            apply(__MODULE__, String.to_atom(action), [args | [options]])
        end
      end

      def help do
        for {action, %{description: desc}} <-
              Enum.reject(@actions, fn {name, _} -> name == :run end) do
          {action, desc}
        end
      end

      def help(action_key) do
        key = String.to_existing_atom(action_key)
        action = Keyword.get(@actions, key)
        options_desc = Enum.map(action.options, fn(opt) ->
          case opt do
            {key, config} ->
              {key, Keyword.get(config, :description)}
            {key} ->
              {key}
          end
        end)
        {key, action.description, options_desc}
      end
    end
  end
end
