defmodule Colossus.IO do
  defmacro __using__(_args) do
    quote do
      def puts(message), do: dispatch({:puts, message})

      def begin, do: dispatch(:begin)

      def commit, do: dispatch(:commit)

      def live, do: dispatch(:live)

      defp dispatch(data) do
        case Process.get(Colossus.IO) do
          nil ->
            raise RuntimeError,
                  "You can't access to Colossus.IO function from another process. Please, make only syncronous calls!"

          function when is_function(function) ->
            function.(data)

          module when is_atom(module) ->
            dispatch_module(module, data)

          pid when is_pid(pid) ->
            send(pid, data)
        end
      end

      defp dispatch_module(module, :begin), do: module.begin()
      defp dispatch_module(module, :commit), do: module.commit()
      defp dispatch_module(module, :live), do: module.live()
      defp dispatch_module(module, {:puts, data}), do: module.puts(data)
    end
  end
end
