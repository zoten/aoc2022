defmodule Aoc.Days.Day5 do
  use Aoc.Day,
    day: 5,
    read: [trim_leading: false]

  @regex ~r/move (?<what>\d+) from (?<from>\d+) to (?<to>\d+)/

  def solution(1, input) do
    input
    |> parse()
    |> execute(1)
    |> Enum.map(fn
      {_, []} -> ""
      {_, stack} -> hd(stack)
    end)
    |> Enum.join()
  end

  def solution(2, input) do
    input
    |> parse()
    |> execute(2)
    |> Enum.map(fn
      {_, []} -> ""
      {_, stack} -> hd(stack)
    end)
    |> Enum.join()
  end

  defp execute({cols, instructions}, 1) do
    move(cols, instructions)
  end

  defp execute({cols, instructions}, 2) do
    move_many(cols, instructions)
  end

  defp move_many(cols, [{what, from, to} | tail] = _instructions) do
    {new_head, new_from} = cols |> Map.fetch!(from) |> Enum.split(what)

    new_cols =
      cols
      |> Map.update!(from, fn _ -> new_from end)
      |> Map.update!(to, fn current_to -> Enum.concat(new_head, current_to) end)

    move_many(new_cols, tail)
  end

  defp move_many(cols, [] = _instructions), do: cols

  defp move(cols, [{what, from, to} | tail]) do
    # IO.inspect(cols)
    # IO.puts("moving #{what} from #{from} to #{to}")

    new_cols =
      1..what
      |> Enum.reduce(
        cols,
        fn _, current_cols ->
          {from_head, new_cols} = pop_stack(current_cols, from)

          new_cols
          |> Map.update!(to, fn stack -> [from_head | stack] end)
        end
      )

    move(new_cols, tail)
  end

  defp move(cols, []), do: cols

  defp pop_stack(cols, from) do
    from_head = cols |> Map.fetch!(from) |> List.first()
    {from_head, cols |> Map.update!(from, fn [_h | t] -> t end)}
  end

  defp parse(lines) do
    parse(lines, {%{}, []}, :cargos)
  end

  defp parse(["" | tail], {cols, instructions} = _acc, :cargos) do
    new_cols = cols |> Enum.map(fn {key, cols} -> {key, Enum.reverse(cols)} end) |> Enum.into(%{})
    parse(tail, {new_cols, instructions}, :instructions)
  end

  defp parse([line | tail], {cols, instructions} = _acc, :cargos) do
    new_cols =
      line
      |> String.codepoints()
      |> Enum.chunk_every(4)
      |> Enum.map(&Enum.join/1)
      |> Enum.map(&String.trim/1)
      # "[A] "
      |> Enum.map(fn
        <<"[", letter::binary-size(1), "]">> -> letter
        <<"">> -> :blank
        # last cargo line is something like " 1  2  3"
        _other -> :index_line
      end)
      |> Enum.reject(fn item -> item == :index_line end)
      |> Enum.with_index()
      |> Enum.reduce(cols, fn {element, index}, updated_cols ->
        # cols start from 1, this will simplify things later
        prepend_to_cols(updated_cols, element, index + 1)
      end)

    parse(tail, {new_cols, instructions}, :cargos)
  end

  defp parse([instruction | tail], {cols, instructions} = _acc, :instructions) do
    %{"what" => what, "from" => from, "to" => to} = Regex.named_captures(@regex, instruction)
    [what, from, to] = Enum.map([what, from, to], &String.to_integer/1)

    parse(tail, {cols, [{what, from, to} | instructions]}, :instructions)
  end

  defp parse([], {cols, instructions} = _acc, _), do: {cols, Enum.reverse(instructions)}

  # defp chunk_every(str, n) do
  #   for <<x::binary-size(n) <- str>>, do: x
  # end

  defp prepend_to_cols(cols, :blank, _index), do: cols

  defp prepend_to_cols(cols, element, index) do
    Map.update(
      cols,
      index,
      [element],
      fn x -> [element | x] end
    )
  end
end
