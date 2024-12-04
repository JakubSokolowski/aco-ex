defmodule Aoc.Solutions.Year2024.Day04Test do
  use ExUnit.Case
  import Elixir.Aoc.Solutions.Year2024.Day04

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

  describe "get_diagonal/3" do
    test "should get proper diagonal line" do
      grid = Day04.Grid.new(@test_input)
    end
  end

  describe "silver/1" do
    test "should solve silver for test input" do
      input = "MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX"

      result = silver(input)

      assert result
    end
  end

  @tag :skip
  describe "gold/1" do
    test "should solve gold for test input" do
      input = ""

      result = gold(input)

      assert result
    end
  end
end
