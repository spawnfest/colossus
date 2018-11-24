defmodule Colossus.DSL do
  def __on_definition__(env, :def, name, _args, _guards, _body) do
    desc = Module.get_attribute(env.module, :desc) 
    options = Module.get_attribute(env.module, :option) 

    Module.put_attribute(env.module, :actions, {name, desc, options})

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

  defmacro __before_compile__(_env) do
    quote do
      def run([]) do
        help
      end

      def run([action | args]) do
        apply(__MODULE__, String.to_atom(action), args)
      end

      def help do
        IO.inspect(@actions)
        for {action, desc, _} <- Enum.reject(@actions, fn {name, _, _} -> name == :run end) do
          IO.puts "#{action} - #{desc}"
        end
        :ok
      end
    end
  end
end
