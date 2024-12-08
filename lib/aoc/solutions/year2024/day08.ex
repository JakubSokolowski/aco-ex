defmodule Aoc.Solutions.Year2024.Day08 do
  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @impl true
  def silver(input) do
    grid = Grid.parse(input)

    values =
      Grid.find_all(grid)
      |> Map.drop(["."])

    points =
      values
      |> Enum.map(fn {antenna, _} ->
        get_antinodes(values, antenna)
      end)
      |> List.flatten()
      |> Enum.filter(fn {x, y} -> Grid.in_bounds?(grid, {x, y}) end)
      |> Enum.uniq()

    points |> Enum.count()
  end

  @impl true
  def gold(input) do
    grid = Grid.parse(input)

    values =
      Grid.find_all(grid)
      |> Map.drop(["."])

    points =
      values
      |> Enum.map(fn {antenna, _} ->
        get_all_antinodes(grid, values, antenna)
      end)
      |> List.flatten()
      |> Enum.filter(fn {x, y} -> Grid.in_bounds?(grid, {x, y}) end)
      |> Enum.uniq()

    points |> Enum.count()
  end

  def get_antinodes(all_values, antenna) do
    positions = all_values |> Map.get(antenna)

    pairs =
      generate_pairs(positions)

    antinodes =
      pairs
      |> Enum.map(fn {a, b} ->
        pair_antinodes(a, b)
      end)
      |> List.flatten()

    antinodes
  end

  def get_all_antinodes(grid, all_values, antenna) do
    positions = all_values |> Map.get(antenna)

    pairs =
      generate_pairs(positions)

    antinodes =
      pairs
      |> Enum.map(fn {a, b} ->
        all_antinodes(grid, a, b)
      end)
      |> List.flatten()

    antinodes
  end

  def pair_antinodes(a, b) do
    {xa, ya} = a
    {xb, yb} = b

    # delta from a to b
    dxab = xb - xa
    dyab = yb - ya

    # delta from b to a
    dxba = xa - xb
    dyba = ya - yb

    [{xa + dxba, ya + dyba}, {xb + dxab, yb + dyab}]
  end

  def all_antinodes(grid, a, b) do
    {xa, ya} = a
    {xb, yb} = b

    dxab = xb - xa
    dyab = yb - ya

    dxba = xa - xb
    dyba = ya - yb

    # away from b
    points_from_a =
      Stream.iterate({xa + dxba, ya + dyba}, fn {x, y} ->
        {x + dxba, y + dyba}
      end)
      |> Stream.take_while(fn point -> Grid.in_bounds?(grid, point) end)

    # away from a
    points_from_b =
      Stream.iterate({xb + dxab, yb + dyab}, fn {x, y} ->
        {x + dxab, y + dyab}
      end)
      |> Stream.take_while(fn point -> Grid.in_bounds?(grid, point) end)

    all_points = Enum.to_list(points_from_a) ++ Enum.to_list(points_from_b)
    all_points ++ [a, b]
  end

  def generate_pairs(positions) do
    for a <- positions,
        b <- positions,
        a < b,
        do: {a, b}
  end
end
