defmodule Aoc.Solutions.Grid do
  defstruct [
    :values,
    :width,
    :height
  ]

  @directions [
    {0, 1},
    {1, 0},
    {1, 1},
    {1, -1},
    {0, -1},
    {-1, 0},
    {-1, -1},
    {-1, 1}
  ]

  def dirs() do
    @directions
  end

  def new(values, width, height) do
    %__MODULE__{values: values, width: width, height: height}
  end

  def parse(values) do
    rows =
      values
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, "", trim: true))

    width = length(hd(rows))
    height = length(rows)

    flat =
      rows
      |> List.flatten()

    new(flat, width, height)
  end

  def print(grid) do
    Enum.chunk_every(grid.values, grid.width, grid.width, :discard)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts/1)
  end

  def element_at(grid, x, y) do
    grid.values
    |> Enum.at(y * grid.width + x)
  end

  def get_line(grid, {x, y}, {dx, dy}, len) do
    coords =
      0..len
      |> Enum.map(fn i -> {x + i * dx, y + i * dy} end)
      |> Enum.filter(fn {x, y} -> in_bounds?(grid, {x, y}) end)

    {coords,
     coords
     |> Enum.map(fn {x, y} -> element_at(grid, x, y) end)}
  end

  def in_bounds?(grid, {x, y}) do
    x >= 0 and x < grid.width and y >= 0 and y < grid.height
  end

  def print_only_coords(grid, coords) do
    Enum.chunk_every(grid.values, grid.width, grid.width, :discard)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        if Enum.member?(coords, {x, y}) do
          char
        else
          "."
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.each(&IO.puts/1)
  end

  def find_coords(grid, char) do
    for y <- 0..(grid.height - 1),
        x <- 0..(grid.width - 1),
        element_at(grid, x, y) == char,
        do: {x, y}
  end
end
