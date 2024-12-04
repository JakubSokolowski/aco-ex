defmodule Aoc.Solutions.GridTest do
  use ExUnit.Case

  alias Aoc.Solutions.Grid

  @test_input """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  @test_input_min """
  XMAS
  SMAX
  XMAS
  XMXS
  """

  @test_cmas_input_min """
  XMAS
  SMAS
  XMAS
  XMXS
  """

  describe "parse/1" do
    test "should parse min grid" do
      grid = Grid.parse(@test_input_min)

      dbg(grid)

      assert grid.width == 4
      assert grid.height == 4
    end
  end

  describe "find_coords/2" do
    test "should find all X coords for min grid" do
      grid = Grid.parse(@test_input_min)

      coords = Grid.find_coords(grid, "X")

      dbg(coords)

      assert coords == []
    end
  end

  describe "get_line/3" do
    test "should get line in grid" do
      grid = Grid.parse(@test_input_min)

      line = Grid.get_line(grid, {0, 0}, {1, 1}, 3)

      dbg(line)

      assert line == []
    end
  end

  describe "count_word/2" do
    test "should count word in min grid" do
      grid = Grid.parse(@test_input_min)

      count = Grid.count_word(grid, "XMAS")

      assert count == 4
    end

    test "should count word in grid for test input" do
      grid = Grid.parse(@test_input)

      count = Grid.count_word(grid, "XMAS")

      assert count == 18
    end

    test "should count word in grid for real input" do
      input = Aoc.Solver.fetch_input(2024, 4)

      grid = Grid.parse(input)

      count = Grid.count_word(grid, "XMAS")

      assert count == 2500
    end
  end

  describe "find_word/3" do
    test "should find word in grid" do
      grid = Grid.parse(@test_input_min)

      words = Grid.find_word_lines(grid, {0, 0}, "XMAS", Grid.dirs())

      assert words == [
               %{
                 line: ["X", "M", "A", "S"],
                 start: {0, 0},
                 coords: [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
                 delta: {1, 0}
               },
               %{
                 line: ["X", "M", "A", "S"],
                 start: {0, 0},
                 coords: [{0, 0}, {1, 1}, {2, 2}, {3, 3}],
                 delta: {1, 1}
               }
             ]
    end
  end

  describe "count_x_mases/1" do
    test "should find X-masses in min grid" do
      grid = Grid.parse(@test_input_min)

      count = Grid.count_x_mases(grid)

      assert count == 1
    end

    test "should find X-masses in test grid" do
      grid = Grid.parse(@test_input)

      count = Grid.count_x_mases(grid)

      assert count == 9
    end

    test "should find X-masses in real grid" do
      input = Aoc.Solver.fetch_input(2024, 4)
      grid = Grid.parse(input)

      count = Grid.count_x_mases(grid)

      assert count == 9
    end
  end
end
