defmodule Gists do
  @doc """
  Write with string rewriting
  """

  def rewrite do
    for i <- 1..100 do
      :timer.sleep(100)
      IO.write("\rReady: #{i}%" |> String.pad_trailing(80))
    end
  end
end
