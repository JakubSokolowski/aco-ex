defmodule Aoc.Solutions.Year2020.TemplateTest do
  use ExUnit.Case
  alias Aoc.Solutions.Year2020.Template

  describe "silver/1" do
    test "solves the silver challenge for a test input" do
      input = """
      """

      assert Template.silver(input) == "Silver"
    end
  end

  describe "gold/1" do
    test "solves the gold challenge with a valid input" do
      input = """
      """

      assert Template.gold(input) == "Gold"
    end
  end
end
