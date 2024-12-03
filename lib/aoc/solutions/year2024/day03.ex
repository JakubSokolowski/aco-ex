defmodule Aoc.Solutions.Year2024.Day03 do
  @behaviour Aoc.Solution

  @mul_pattern ~r/mul\((\d+),(\d+)\)/
  @do_pattern ~r/do\(\)/
  @dont_pattern ~r/don't\(\)/

  @impl true
  def silver(input) do
    Regex.scan(@mul_pattern, input)
    |> Enum.map(fn [_, l, r] -> String.to_integer(l) * String.to_integer(r) end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    muls =
      Regex.scan(@mul_pattern, input, return: :index)
      |> Enum.map(fn [{start_pos, length}, _, _] ->
        match = String.slice(input, start_pos, length)
        {match, start_pos, start_pos + length - 1}
      end)

    dos =
      Regex.scan(@do_pattern, input, return: :index)
      |> Enum.map(fn [{start_pos, length}] ->
        match = String.slice(input, start_pos, length)
        {match, start_pos, start_pos + length - 1}
      end)

    donts =
      Regex.scan(@dont_pattern, input, return: :index)
      |> Enum.map(fn [{start_pos, length}] ->
        match = String.slice(input, start_pos, length)
        {match, start_pos, start_pos + length - 1}
      end)

    valid_muls =
      Enum.filter(muls, fn mul ->
        not is_disabled(mul, dos, donts)
      end)

    sum =
      valid_muls
      |> Enum.map(fn {match, _, _} ->
        [left, right] =
          Regex.scan(~r/\d+/, match) |> List.flatten() |> Enum.map(&String.to_integer/1)

        left * right
      end)
      |> Enum.sum()

    sum
  end

  def is_disabled(mul, dos, donts) do
    all = Enum.sort_by(dos ++ donts, fn {_, start, _} -> start end)
    {_, mul_start, _} = mul

    prevs =
      all
      |> Enum.filter(fn {_, start, _} -> start < mul_start end)

    closest_prev = prevs |> List.last()

    disabled =
      case closest_prev do
        nil ->
          false

        {match, _, _} ->
          case match do
            "do()" -> false
            "don't()" -> true
          end
      end

    disabled
  end
end
