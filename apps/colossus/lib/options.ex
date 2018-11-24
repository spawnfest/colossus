defmodule Colossus.Options do
  def handle_options(function_options, passed_options) do
    Enum.reduce(function_options, passed_options, fn (func_opt, acc_passed_options) ->
      handle_option(func_opt, acc_passed_options)
    end)
  end

  def handle_option(opt, passed_options) do
    {key, specs} = opt
    Enum.reduce(specs, passed_options, fn (spec, acc) ->
      case spec do
        {:required, true} ->
          validate_required(opt, acc)
          acc
        {:default, value} ->
          set_default_value(acc, key, value)
        _ ->
          acc
      end
    end)
  end

  defp validate_required({key, _value} = opt, passed_options) do
    case Map.fetch(passed_options, key) do
      {:ok, value} ->
        value
      _ ->
        raise "required options #{key} missing"
    end
    opt
  end

  defp set_default_value(passed_options, key, value) do
    if Map.has_key?(passed_options, key) do
      passed_options
    else
      Map.put(passed_options, key, value)
    end
  end
end
