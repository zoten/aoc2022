defmodule Aoc.Common.Reader do
  @input_paths "priv/inputs"

  def read!(day, env \\ :main, opts \\ [])

  def read!(day, :test, opts), do: do_read!("day#{day}_test.txt", opts)
  def read!(day, :main, opts), do: do_read!("day#{day}.txt", opts)

  defp do_read!(name, opts) do
    split = Keyword.get(opts, :split, true)
    split_by = Keyword.get(opts, :split_by, "\n")
    trim_leading = Keyword.get(opts, :trim_leading, true)
    trim_trailing = Keyword.get(opts, :trim_trailing, true)

    @input_paths
    |> Path.join(name)
    |> File.read!()
    |> maybe_trim_leading(trim_leading)
    |> maybe_trim_trailing(trim_trailing)
    |> maybe_split(split_by, split)
  end

  defp maybe_split(s, _, false), do: s
  defp maybe_split(s, split_by, true), do: String.split(s, split_by)

  defp maybe_trim_leading(s, false), do: s
  defp maybe_trim_leading(s, true), do: String.trim_leading(s)

  defp maybe_trim_trailing(s, false), do: s
  defp maybe_trim_trailing(s, true), do: String.trim_trailing(s)
end
