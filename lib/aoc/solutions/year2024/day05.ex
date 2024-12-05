defmodule Aoc.Solutions.Year2024.Day05 do
  @behaviour Aoc.Solution

  @impl true
  def silver(input) do
    [rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> then(fn [rules, updates] -> [parse_rules(rules), parse_updates(updates)] end)

    middles =
      updates
      |> Enum.filter(fn update -> updated_valid?(rules, update) end)
      |> Enum.map(fn update -> get_middle(update) end)

    dbg(middles)

    middles |> Enum.sum()
  end

  @impl true
  def gold(input) do
    [rules, updates] =
      input
      |> String.split("\n\n", trim: true)
      |> then(fn [rules, updates] -> [parse_rules(rules), parse_updates(updates)] end)

    dbg(rules)

    incorrect =
      updates
      |> Enum.filter(fn update -> not updated_valid?(rules, update) end)

    dbg(incorrect)

    sorted =
      incorrect
      |> Enum.map(fn update ->
        Enum.sort(update, fn a, b ->
          MapSet.member?(rules, {a, b})
        end)
      end)

    dbg(sorted)

    sorted
    |> Enum.map(fn update -> get_middle(update) end)
    |> Enum.sum()
  end

  def get_middle(list) do
    Enum.at(list, div(length(list), 2))
  end

  def updated_valid?(rules, update) do
    update
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [first, second] -> pair_valid?(rules, first, second) end)
  end

  def pair_valid?(rules, first, second) do
    MapSet.member?(rules, {first, second})
  end

  def sort(list, rules) when is_list(list) do
    do_sort(list, length(list), rules)
  end

  defp do_sort(list, n, _rules) when n <= 1, do: list

  defp do_sort(list, n, rules) do
    {new_list, swapped} = do_iteration(list, rules)

    case swapped do
      true -> do_sort(new_list, n - 1, rules)
      false -> new_list
    end
  end

  defp do_iteration(list, rules) do
    list
    |> Enum.reduce({[], false}, fn
      elem, {[], _swapped} ->
        {[elem], false}

      elem, {[head | tail], swapped} ->
        if pair_valid?(rules, elem, head) do
          {[head | [elem | tail]], swapped}
        else
          {[elem, head | tail], true}
        end
    end)
    |> then(fn {list, swapped} -> {Enum.reverse(list), swapped} end)
  end

  def parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [first, second] = String.split(line, "|")
      {String.to_integer(first), String.to_integer(second)}
    end)
    |> MapSet.new()
  end

  def parse_updates(updates) do
    updates
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      numbers =
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

      List.wrap(numbers)
    end)
  end
end
