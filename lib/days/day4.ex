defmodule Aoc.Days.Day4 do
  use Aoc.Day,
    day: 4

  def solution(1, input) do
    input
    |> Enum.map(&parse_ranges/1)
    |> Enum.count(fn {r0, r1} ->
      contains?(r0, r1) or contains?(r1, r0)
    end)
  end

  def solution(2, input) do
    input
    |> Enum.map(&parse_ranges/1)
    |> Enum.count(fn {r0, r1} ->
      overlaps?(r0, r1) or overlaps?(r1, r0)
    end)
  end

  defp parse_ranges(line) do
    line
    |> String.split(",")
    |> Enum.map(fn part -> String.split(part, "-") end)
    |> (fn [[min0, max0], [min1, max1]] ->
          {
            {min0 |> String.to_integer(), max0 |> String.to_integer()},
            {min1 |> String.to_integer(), max1 |> String.to_integer()}
          }
        end).()
  end

  # true if range0 fully contains range1
  defp contains?({min0, max0} = _range0, {min1, max1} = _range1) do
    min1 >= min0 and min1 <= max0 and
      (max1 >= min0 and max1 <= max0)
  end

  # true if rang0 and range1 overlaps
  defp overlaps?({min0, max0} = _range0, {min1, max1} = _range1) do
    (min0 >= min1 and min0 <= max1) or
      (max0 >= min1 and max0 <= max1)
  end
end
