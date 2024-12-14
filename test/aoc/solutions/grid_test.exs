defmodule Aoc.Solutions.GridTest do
  use ExUnit.Case

  alias Aoc.Solutions.Grid

  @test_input_min """
  XMAS
  SMAX
  XMAS
  XMXS
  """

  describe "find_all/1" do
    test "should group coords by value" do
      grid = Grid.parse(@test_input_min)

      grouped = Grid.find_all(grid)

      assert grouped
    end
  end

  describe "parse/1" do
    test "should parse min grid" do
      grid = Grid.parse(@test_input_min)

      assert grid.width == 4
      assert grid.height == 4
    end
  end

  describe "find_coords/2" do
    test "should find all X coords for min grid" do
      grid = Grid.parse(@test_input_min)

      coords = Grid.find_coords(grid, "X")

      assert coords == [{0, 0}, {3, 1}, {0, 2}, {0, 3}, {2, 3}]
    end
  end

  describe "get_line/3" do
    test "should get line in grid" do
      grid = Grid.parse(@test_input_min)

      line = Grid.get_line(grid, {0, 0}, {1, 1}, 3)

      assert line == {[{0, 0}, {1, 1}, {2, 2}, {3, 3}], ["X", "M", "A", "S"]}
    end
  end

  describe "move_wrap/3" do
    test "should move point in direction, wrapping if oob" do
      grid = Grid.init_empty(11, 7)

      coord = {0, 0}
      direction = {-1, -1}

      new_coord = Grid.move_wrap(grid, coord, direction)

      assert new_coord == {10, 6}
    end
  end
end
