defmodule Colossus.DSL do
  def __on_definition__(env, :def, name, _args, _guards, _body) do
    if desc = Module.get_attribute(env.module, :desc) do
      previous_actions = Module.get_attribute(env.module, :actions)
      if previous_actions do
        Module.put_attribute(env.module, :actions, [{name, desc} | previous_actions])
      else
        Module.put_attribute(env.module, :actions, [{name, desc}])
      end
      Module.delete_attribute(env.module, :desc)
    end
  end

  def __on_definition__(_, _, _, _, _, _) do
  end

  defmacro desc(text) do
    quote do
      @desc unquote(text)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run([]) do
        help
      end

      def run([action | args]) do
        apply(__MODULE__, String.to_atom(action), args)
      end

      def help do
        for {action, desc} <- @actions do
          IO.puts "#{action} - #{desc}"
        end
        :ok
      end
    end
  end
end
