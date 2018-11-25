defmodule Colossus.Encoder do
  @callback encode(any) :: {:ok, String.t()}

  defmacro sigil_E(expr, opts) do
    handle_sigil(expr, opts, __CALLER__.line)
  end

  defp handle_sigil({:<<>>, _, [expr]}, [], line) do
    EEx.compile_string(expr, line: line + 1, trim: true)
  end

  defp handle_sigil(_, _, _) do
    raise ArgumentError,
          "interpolation not allowed in ~e sigil. " <>
            "Remove the interpolation, use <%= %> to insert values, " <>
            "or use ~E to show the interpolation literally"
  end

  def default_encode_help_to_eex(commands) do
    compressed_commands =
      commands
      |> Enum.uniq()
      |> Enum.filter(fn {key, config} ->
        Enum.find(commands, fn {k, v} ->
          k == key && config.description && config.arity == v.arity && is_nil(v.description)
        end)
      end)

    ~E"""
    Available Comands:
     <%= for {name, config} <- commands do %>
       <%= String.pad_trailing(to_string(name) <> "/" <> to_string(config.arity) , 15) <> " # " <> to_string(config.description) %>
     <% end %>
    """
  end

  def default_encode_help_command_to_eex({key, desc, options}) do
    ~E"""
    Command: <%= to_string(key) %> 
    Description: <%= desc %>
    Options: <%= for {name, desc} <- options do %>
       <%= String.pad_trailing(to_string(name), 15) <> " # " <> to_string(desc) %>
     <% end %>
    """
  end
end
