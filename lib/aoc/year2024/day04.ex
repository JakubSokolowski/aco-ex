defmodule Aoc.Solutions.Year2024.Day04 do
  alias Elixir.Aoc.Solutions.Grid

  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    grid = Grid.parse(input)
    count = Grid.count_xmas(grid)

    dbg(count)

    "Silver"
  end

  def horiz_forward(input) do
    input
    |> String.trim()
  end

  @impl true
  def gold(input) do
    "Gold"
  end
end
