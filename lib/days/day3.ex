defmodule Aoc.Days.Day3 do
  use Aoc.Day,
    day: 3

  @priorities_lowercase "abcdefghijklmnopqrstuvwxyz"
                        |> String.to_charlist()
                        |> Enum.map(fn char ->
                          {char, char - 96}
                        end)
                        |> Enum.into(%{})
  @priorities_upper "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    |> String.to_charlist()
                    |> Enum.map(fn char ->
                      {char, char - 38}
                    end)
                    |> Enum.into(%{})

  @priorities Map.merge(@priorities_lowercase, @priorities_upper)

  def solution(1, input) do
    input
    |> Enum.map(&parse_priority/1)
    |> Enum.map(&rucksacks/1)
    |> Enum.map(&both/1)
    |> Enum.sum()
  end

  def solution(2, input) do
    input
    |> Enum.map(&parse_priority/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [r1, r2, r3] ->
      MapSet.intersection(
        MapSet.intersection(MapSet.new(r1), MapSet.new(r2)) |> MapSet.new(),
        MapSet.new(r3)
      )
      |> MapSet.to_list()
      |> hd
    end)
    |> Enum.sum()
  end

  defp both([r1, r2]) do
    MapSet.intersection(MapSet.new(r2), MapSet.new(r1)) |> MapSet.to_list() |> hd
  end

  defp rucksacks(line) do
    [r1, r2] = Enum.chunk_every(line, ceil(length(line) / 2))
    [Enum.sort(r1), Enum.sort(r2)]
  end

  defp parse_priority(line), do: line |> String.to_charlist() |> Enum.map(&priority/1)
  defp priority(char), do: Map.fetch!(@priorities, char)
end
