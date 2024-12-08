defmodule Aoc.Solutions.Year2024.Day08Test do
  use ExUnit.Case
  import Elixir.Aoc.Solutions.Year2024.Day08
  alias Aoc.Solutions.Grid

  @day 08
  @year 2024
  @test_input """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  @min_antennas_input """
  ..........
  ..........
  ..........
  ....a.....
  ..........
  .....a....
  ..........
  ..........
  ..........
  ..........
  """

  @t_antennas_input """
  T.........
  ...T......
  .T........
  ..........
  ..........
  ..........
  ..........
  ..........
  ..........
  ..........
  """

  describe "get_antinodes/3" do
    setup do
      grid = Grid.parse(@min_antennas_input)

      values =
        Grid.find_all(grid)
        |> Map.drop(["."])

      {:ok, %{grid: grid, values: values}}
    end

    test "should get antinodes for min input", %{values: values} do
      result = get_antinodes(values, "a")
      assert result == [{3, 1}, {6, 7}]
    end
  end

  describe "pair_antinodes/2" do
    test "should return all antinodes for the pair" do
      result = pair_antinodes({4, 3}, {5, 5})
      assert result
    end
  end

  describe "silver/1" do
    test "should solve silver for test input" do
      input = @test_input

      result = silver(input)

      assert result == 14
    end

    test "should solve silver for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = silver(input)

      assert result == 400
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = @test_input

      result = gold(input)

      assert result == 34
    end

    test "should solve gold for t input" do
      input = @t_antennas_input

      result = gold(input)

      assert result == 9
    end

    test "should solve gold for real input" do
      input = Aoc.Solver.fetch_input(@year, @day)

      result = gold(input)

      assert result == 1280
    end
  end
end
