defmodule Aoc do
  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Solve a specific day/part challenge
  """
  def solve(day, part \\ 1) do
    module_name = String.to_existing_atom("Aoc.Days.Day#{day}")

    mod = Code.ensure_loaded!(module_name)
    mod.solve(part)
  end
end
