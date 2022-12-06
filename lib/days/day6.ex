defmodule Aoc.Days.Day6 do
  use Aoc.Day,
    day: 6,
    read: [split: false]

  def solution(1, input) do
    input
    |> String.codepoints()
    |> Enum.split(3)
    |> marker()
  end

  def solution(2, input) do
    input
    |> String.codepoints()
    |> Enum.split(13)
    |> message()
  end

  defp message({window, rest}) do
    rest |> do_message({window, 14})
  end

  defp do_message([item | items], {[_h | t] = current_window, step}) do
    case [item | current_window]
         |> Enum.frequencies()
         |> Enum.all?(fn {_, count} -> count == 1 end) do
      false -> do_message(items, {Enum.concat(t, [item]), step + 1})
      true -> step
    end
  end

  defp marker({[a, b, c], rest}) do
    do_marker(rest, {[a, b, c], 4})
  end

  defp do_marker([item | _items], {[a, b, c] = _current_window, step})
       when item != a and item != b and item != c and a != b and a != c and b != c do
    step
  end

  defp do_marker([item | items], {[_a, b, c] = _current_window, step}) do
    do_marker(items, {[b, c, item], step + 1})
  end
end
