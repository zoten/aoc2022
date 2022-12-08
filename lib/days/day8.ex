defmodule Aoc.Days.Day8 do
  use Aoc.Day,
    day: 8

  def solution(1, input) do
    {matrix, transposed} = input |> parse()
    visibles(matrix, transposed) |> count_visibles()
  end

  def solution(2, input) do
    {matrix, transposed} = input |> parse()
    scenic_scores(matrix, transposed) |> Enum.max()
  end

  defp scenic_scores([hm | _tailm] = matrix, [ht | _tailt] = transposed) do
    horizontal_length = length(hm)
    vertical_length = length(ht)

    Enum.with_index(
      matrix,
      fn row, row_idx ->
        Enum.with_index(
          row,
          fn tree, col_idx ->
            transposed_row = transposed |> Enum.at(col_idx)

            {h0, h1} = scenic_score(row, tree, col_idx, horizontal_length)

            {v0, v1} = scenic_score(transposed_row, tree, row_idx, vertical_length)

            h0 * h1 * v0 * v1
          end
        )
      end
    )
    |> List.flatten()
  end

  defp scenic_score(_row, _tree, idx, len) when idx == 0 or idx == len - 1, do: {0, 0}

  defp scenic_score(row, tree, idx, len) do
    trees_before = Enum.slice(row, 0..(idx - 1)) |> Enum.reverse()

    trees_after = Enum.slice(row, (idx + 1)..(len - 1))

    score_left =
      Enum.reduce_while(trees_before, 0, fn height, acc ->
        if height < tree do
          {:cont, acc + 1}
        else
          if height == tree do
            {:halt, acc + 1}
          else
            {:halt, acc}
          end
        end
      end)

    score_right =
      Enum.reduce_while(trees_after, 0, fn height, acc ->
        if height < tree do
          {:cont, acc + 1}
        else
          if height == tree do
            {:halt, acc + 1}
          else
            {:halt, acc}
          end
        end
      end)

    {score_left, score_right}
  end

  defp count_visibles(matrix) do
    Enum.reduce(
      matrix,
      0,
      fn row, acc ->
        acc +
          Enum.reduce(
            row,
            0,
            fn
              {v0, v1, _}, acc when v0 in [true, :external] or v1 in [true, :external] -> acc + 1
              _, acc -> acc
            end
          )
      end
    )
  end

  defp visibles([hm | _tailm] = matrix, [ht | _tailt] = transposed) do
    horizontal_length = length(hm)
    vertical_length = length(ht)

    Enum.with_index(
      matrix,
      fn row, row_idx ->
        Enum.with_index(
          row,
          fn tree, col_idx ->
            transposed_row = transposed |> Enum.at(col_idx)

            {visible?(row, tree, col_idx, horizontal_length),
             visible?(transposed_row, tree, row_idx, vertical_length), tree}
          end
        )
      end
    )
  end

  defp visible?(_row, _tree, idx, _horizontal_length) when idx == 0,
    do: :external

  defp visible?(_row, _tree, idx, len) when idx == len - 1,
    do: :external

  defp visible?(row, tree, idx, len) do
    # ^tree = Enum.at(row, idx)
    trees_before = Enum.slice(row, 0..(idx - 1))

    trees_after = Enum.slice(row, (idx + 1)..(len - 1))

    Enum.all?(trees_before, fn height -> height < tree end) or
      Enum.all?(trees_after, fn height -> height < tree end)
  end

  def parse(lines) do
    matrix =
      Enum.map(lines, fn line -> line |> String.codepoints() |> Enum.map(&String.to_integer/1) end)

    # transposed
    transposed = Enum.zip_with(matrix, & &1)

    {matrix, transposed}
  end
end
