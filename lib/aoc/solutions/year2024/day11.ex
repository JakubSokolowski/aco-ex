defmodule Aoc.Solutions.Year2024.Day11 do
  @tags [:memoization]

  @moduledoc """
  Tags: #{inspect(@tags)}

  For both parts, do not keep the stones itself in memory, just their counts

  """

  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    input
    |> parse_counts()
    |> blink_times(25)
    |> Map.values()
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    input
    |> parse_counts()
    |> blink_times(75)
    |> Map.values()
    |> Enum.sum()
  end

  def blink_times(counts, n) do
    Enum.reduce(1..n, counts, fn _i, acc -> blink(acc) end)
  end

  def stone_counts(stones) do
    Enum.reduce(stones, %{}, fn stone, acc -> acc |> Map.update(stone, 1, &(&1 + 1)) end)
  end

  def count_digits(num) do
    num |> Integer.to_string() |> String.length()
  end

  def blink(counts) do
    Enum.reduce(counts, %{}, fn {num, count}, acc ->
      cond do
        count_digits(num) |> rem(2) == 0 ->
          {first, second} = split_num(num)

          acc
          |> Map.update(first, count, &(&1 + count))
          |> Map.update(second, count, &(&1 + count))

        num == 0 ->
          acc |> Map.update(1, count, &(&1 + count))

        true ->
          acc |> Map.update(num * 2024, count, &(&1 + count))
      end
    end)
  end

  def split_num(num) do
    num_str = Integer.to_string(num)
    len = String.length(num_str)

    num_str
    |> String.split_at(div(len, 2))
    |> then(fn {first, second} ->
      {String.to_integer(first), String.to_integer(second)}
    end)
  end

  def parse_counts(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn num, acc ->
      Map.put(acc, num, 1)
    end)
  end
end
