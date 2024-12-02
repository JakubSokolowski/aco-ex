defmodule Aoc.Solutions.Year2024.Day02 do
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    to_reports(input)
    |> Enum.count(fn r -> valid(r) end)
  end

  @impl true
  def gold(input) do
    to_reports(input)
    |> Enum.count(fn r -> valid_dampened(r) end)
  end

  def valid_dampened(report) do
    if valid(report) do
      true
    end

    0..(length(report) - 1)
    |> Enum.map(fn x -> Enum.take(report, x) ++ Enum.drop(report, x + 1) end)
    |> Enum.any?(fn x -> valid(x) end)
  end

  def valid(report) do
    diffs =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    all_increasing =
      diffs
      |> Enum.all?(fn x -> x >= 1 end)

    all_decreasing =
      diffs
      |> Enum.all?(fn x -> x <= 0 end)

    all_diffs_in_range =
      diffs
      |> Enum.all?(fn x -> abs(x) >= 1 and abs(x) <= 3 end)

    (all_decreasing || all_increasing) && all_diffs_in_range
  end

  def to_reports(input) do
    String.split(input, "\n", trim: true)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn x ->
      String.split(x, " ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(&(&1 != []))
  end
end
