defmodule Aoc.Solutions.Year2024.Day13 do
  @behaviour Aoc.Solution

  @tags [:math, :linear_algebra]

  @impl true
  def silver(input) do
    machines = parse_machines(input)

    machines
    |> Enum.map(&solve_machine/1)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    machines = parse_machines(input)
    delta = 10_000_000_000_000

    machines
    |> Enum.map(fn machine ->
      [a1, a2, b1, b2, res1, res2] = machine
      [a1, a2, b1, b2, res1 + delta, res2 + delta]
    end)
    |> Enum.map(&solve_machine/1)
    |> Enum.sum()
  end

  def parse_machines(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&all_nums/1)
  end

  def all_nums(input) do
    Regex.scan(~r/-?\d*\.?\d+/, input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  def solve_machine([a1, a2, b1, b2, res1, res2]) do
    n1 = b2 * res1 - b1 * res2
    d1 = a1 * b2 - a2 * b1

    t = div(n1, d1)
    n2 = res1 - a1 * t
    d2 = b1

    cond do
      rem(n1, d1) != 0 -> 0
      rem(n2, d2) != 0 -> 0
      true -> 3 * t + div(n2, d2)
    end
  end
end
