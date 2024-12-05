defmodule Aoc.Solutions.Year2024.Day05Test do
  use ExUnit.Case
  import Elixir.Aoc.Solutions.Year2024.Day05

  @test_input """
  47|53
  97|13
  97|61
  97|47
  75|29
  61|13
  75|53
  29|13
  97|29
  53|29
  61|53
  97|53
  61|29
  47|13
  75|47
  97|75
  47|61
  75|61
  47|29
  75|13
  53|13

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  75,97,47,61,53
  61,13,29
  97,13,75,29,47
  """

  @rules MapSet.new([
           {29, 13},
           {47, 13},
           {47, 29},
           {47, 53},
           {47, 61},
           {53, 13},
           {53, 29},
           {61, 13},
           {61, 29},
           {61, 53},
           {75, 13},
           {75, 29},
           {75, 47},
           {75, 53},
           {75, 61},
           {97, 13},
           {97, 29},
           {97, 47},
           {97, 53},
           {97, 61},
           {97, 75}
         ])

  describe "silver/1" do
    test "should solve silver for test input" do
      result = silver(@test_input)

      assert result == 143
    end
  end

  describe "gold/1" do
    test "should solve gold for test input" do
      result = gold(@test_input)

      assert result == 1
    end
  end

  describe "sort" do
    test "should sort invalid input" do
      invalid = [75, 97, 47, 61, 53]

      sorted = sort(invalid, @rules)

      assert sorted == [97, 75, 47, 61, 53]
    end

    test "should sort min case" do
      invalid = [61, 13, 29]

      sorted = sort(invalid, @rules)

      assert sorted == [61, 29, 13]
    end
  end
end
