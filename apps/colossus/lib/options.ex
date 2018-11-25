defmodule Colossus.Options do
  def handle_options(function_options, passed_options, module_options \\ []) do
    options_config = module_options ++ function_options
    filtred_passed_options = Map.take(passed_options, Keyword.keys(options_config))

    Enum.reduce(options_config, filtred_passed_options, fn combo_opts, acc_passed_options ->
      handle_option(combo_opts, acc_passed_options)
    end)
  end

  def handle_option({key, specs} = opt, passed_options) do
    Enum.reduce(specs, passed_options, fn spec, acc ->
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

  def handle_option({key}, passed_options) do
    passed_options
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
