defmodule Aoc.Days.Day1 do
  use Aoc.Day,
    day: 1,
    read: [split_by: "\n\n"]

  def parse(input) do
    input
    |> Enum.map(fn part ->
      part |> String.split() |> Enum.map(&String.to_integer/1) |> Enum.sum()
    end)
  end

  def solution(1, input) do
    input
    |> parse()
    |> Enum.max()
  end

  def solution(2, input) do
    input
    |> parse()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
