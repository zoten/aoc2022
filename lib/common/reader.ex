defmodule Aoc.Common.Reader do
  @input_paths "priv/inputs"

  def read!(day, env \\ :main, opts \\ [])

  def read!(day, :test, opts), do: do_read!("day#{day}_test.txt", opts)
  def read!(day, :main, opts), do: do_read!("day#{day}.txt", opts)

  defp do_read!(name, opts) do
    split = Keyword.get(opts, :split, true)
    split_by = Keyword.get(opts, :split_by, "\n")

    @input_paths
    |> Path.join(name)
    |> File.read!()
    |> String.trim()
    |> maybe_split(split_by, split)
  end

  defp maybe_split(s, _, false), do: s
  defp maybe_split(s, split_by, true), do: String.split(s, split_by)
end
