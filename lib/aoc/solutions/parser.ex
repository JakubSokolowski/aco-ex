defmodule Aoc.Solutions.Parser do
  def parse_nums(input) do
    Regex.scan(~r/-?\d*\.?\d+/, input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
