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
