defmodule Aoc.Day do
  @callback solution(part :: integer(), input :: list(String.t()) | String.t()) :: any()

  @callback solve(part :: integer(), env :: :test | :main) :: any()
  @callback tsolve(part :: integer()) :: any()
  @callback read!(part :: integer(), env :: :test | :main, opts :: Keyword.t()) :: any()

  defmacro __using__(opts) do
    day = Keyword.fetch!(opts, :day)
    read_opts = Keyword.get(opts, :read, [])

    quote do
      @behaviour Aoc.Day

      def solve(part \\ 1, env \\ :main) do
        input = read!(part, env, unquote(read_opts))
        solution(part, input)
      end

      def tsolve(part \\ 1), do: solve(part, :test)

      # commodities
      def solve1, do: solve(1, :main)
      def solve2, do: solve(2, :main)
      def tsolve1, do: solve(1, :test)
      def tsolve2, do: solve(2, :test)

      def read!(part, env, opts) when env in [:test, :main],
        do: Aoc.Common.Reader.read!(unquote(day), env, opts)
    end
  end
end
