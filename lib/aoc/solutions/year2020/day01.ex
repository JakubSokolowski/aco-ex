defmodule Aoc.Solutions.Year2020.Day01 do
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    numbers =
      input
      |> to_nums()

    case find_pair_sum(numbers, 2020) do
      {a, b} -> "#{a * b}"
      _ -> "No pair found"
    end
  end

  def to_nums(input) do
    String.split(input, "\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
  end

  def find_pair_sum(nums, target) do
    Enum.reduce_while(nums, MapSet.new(), fn num, seen ->
      missing = target - num

      if MapSet.member?(seen, missing) do
        {:halt, {num, missing}}
      else
        {:cont, MapSet.put(seen, num)}
      end
    end)
    |> case do
      {_, _} = pair -> pair
      _ -> nil
    end
  end

  def find_triplet_sum(nums, target) do
    pairs_lookup =
      Enum.reduce(nums, Map.new(), fn num, lookup ->
        new_target = target - num

        case find_pair_sum(nums, new_target) do
          {a, b} -> Map.put(lookup, new_target, {a, b})
          _ -> lookup
        end
      end)

    Enum.find_value(nums, fn num ->
      new_target = target - num

      case Map.get(pairs_lookup, new_target) do
        {a, b} when a != num and b != num -> {num, a, b}
        _ -> nil
      end
    end)
  end

  @impl true
  def gold(input) do
    nums =
      input
      |> to_nums()

    case find_triplet_sum(nums, 2020) do
      {a, b, c} -> "#{a * b * c}"
      _ -> "No triplet found"
    end
  end
end
