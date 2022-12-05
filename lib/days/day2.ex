defmodule Aoc.Days.Day2 do
  use Aoc.Day,
    day: 2

  # A rock
  # B paper
  # C scissors
  # Y paper 2
  # X rock 1
  # Z scissors 3

  # 6 win
  # 3 draw
  # 0
  def solution(1, input) do
    input
    |> Enum.map(&parse_line/1)
    |> Enum.map(&outcome_win/1)
    |> Enum.sum()
  end

  # X you need to lose
  # Y you need to draw
  # Z you need to win
  def solution(2, input) do
    input
    |> Enum.map(&parse_line2/1)
    |> Enum.map(&outcome_out/1)
    |> Enum.sum()
  end

  # outcome for part 1
  defp outcome_win([him, me]) do
    case wins(me, him) do
      :win -> 6 + value(me)
      :draw -> 3 + value(me)
      _ -> 0 + value(me)
    end
  end

  # outcome for part 2
  defp outcome_out([him, what]) do
    case what do
      :win -> 6 + (him |> play_to_win() |> value())
      :draw -> 3 + (him |> play_to_draw() |> value())
      :lose -> 0 + (him |> play_to_lose() |> value())
    end
  end

  defp parse_line(line) do
    line |> String.split(" ") |> Enum.map(&to_atom/1)
  end

  defp parse_line2(line) do
    line
    |> String.split(" ")
    |> (fn [what_he_plays, desired_out] ->
          [to_atom(what_he_plays), desired_outcome(desired_out)]
        end).()
  end

  def value(:rock), do: 1
  def value(:paper), do: 2
  def value(:scissors), do: 3

  def to_atom(val) when val in ["A", "X"], do: :rock
  def to_atom(val) when val in ["B", "Y"], do: :paper
  def to_atom(val) when val in ["C", "Z"], do: :scissors

  # me vs him
  defp wins(:paper, :rock), do: :win
  defp wins(:scissors, :paper), do: :win
  defp wins(:rock, :scissors), do: :win
  defp wins(me, him) when me == him, do: :draw
  defp wins(_, _), do: :lose

  # him -> what I should play
  defp play_to_win(:paper), do: :scissors
  defp play_to_win(:scissors), do: :rock
  defp play_to_win(:rock), do: :paper

  defp play_to_lose(:paper), do: :rock
  defp play_to_lose(:scissors), do: :paper
  defp play_to_lose(:rock), do: :scissors

  defp play_to_draw(anything), do: anything

  # X you need to lose
  # Y you need to draw
  # Z you need to win
  defp desired_outcome("X"), do: :lose
  defp desired_outcome("Y"), do: :draw
  defp desired_outcome("Z"), do: :win
end
