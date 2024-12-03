defmodule Aoc.Solutions.Year2024.Day03Test do
  use ExUnit.Case
  import Elixir.Aoc.Solutions.Year2024.Day03

  describe "silver/1" do
    test "should solve silver for test input" do
      input = ""

      result = silver(input)

      assert result
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

      result = gold(input)

      assert result == 4
    end
  end
end
