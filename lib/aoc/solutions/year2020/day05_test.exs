defmodule Aoc.Solutions.Year2020.Day05Test do
  use ExUnit.Case
  alias Aoc.Solutions.Year2020.Day05

  describe "silver/1" do
    test "solves the silver challenge for a test input" do
      input = """
      BFFFBBFRRR
      FFFBBBFRRR
      BBFFBBFRLL
      """

      assert Day05.silver(input) == 820
    end
  end

  describe "seat_id/1" do
    test "computes correct seat id" do
      input = "FBFBBFFRLR"

      assert Day05.seat_id(input) == 357
    end
  end

  describe "next_row/4" do
    test "gets proper row" do
      input = String.to_charlist("FBFBBFFRLR")

      assert Day05.next_row(input, 0, 0, 127) == 44
    end
  end

  describe "next_col/4" do
    test "gets proper col" do
      input = String.to_charlist("FBFBBFFRLR")

      assert Day05.next_col(input, 7, 0, 7) == 5
    end
  end

  describe "gold/1" do
    test "solves the gold challenge with a valid input" do
      input = """
      BFFFBBFRRR
      FFFBBBFRRR
      BBFFBBFRLL
      """

      assert Day05.gold(input) == 120
    end
  end
end
