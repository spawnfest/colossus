defmodule SmartHome do
  @moduledoc """
  This module represents the state of our smart home
  """


  defstruct [
    switches: %{"bulb1" => false, "bulb2" => false},
    washing_machine: %{
      status: :idle, # | :in_progress
      progress: 0
    }
  ]

  @behaviour Access
  @doc false
  def fetch(bot_params, key) do
    Map.fetch(bot_params, key)
  end

  @doc false
  def get(structure, key, default \\ nil) do
    Map.get(structure, key, default)
  end

  @doc false
  def get_and_update(term, key, list) do
    Map.get_and_update(term, key, list)
  end

  @doc false
  def pop(term, key) do
    {get(term, key), term}
  end
end
