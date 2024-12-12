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
    array = :array.from_list(values)
    %__MODULE__{values: array, width: width, height: height}
  end

  def element_at(grid, x, y) do
    :array.get(y * grid.width + x, grid.values)
  end

  def neighbours(grid, {x, y}) do
    Enum.map(@directions, fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(fn {x, y} -> in_bounds?(grid, {x, y}) end)
  end

  def non_diagonal_neighbours(grid, {x, y}) do
    @directions
    |> Enum.filter(fn {dx, dy} -> dx * dy == 0 end)
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(fn {x, y} -> in_bounds?(grid, {x, y}) end)
  end

  def non_diagonal_neighbours_oob(grid, {x, y}) do
    @directions
    |> Enum.filter(fn {dx, dy} -> dx * dy == 0 end)
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
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
    grid.values
    |> :array.to_list()
    |> Enum.chunk_every(grid.width, grid.width, :discard)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts/1)
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

  def add_coords(position, delta) do
    {x, y} = position
    {dx, dy} = delta

    {x + dx, y + dy}
  end

  def set_point(grid, {x, y}, value) do
    new_values = :array.set(y * grid.width + x, value, grid.values)
    %__MODULE__{grid | values: new_values}
  end

  def find_all(grid) do
    indices = :array.sparse_to_orddict(grid.values)

    indices
    |> Enum.group_by(
      fn {_idx, value} -> value end,
      fn {idx, _value} ->
        y = div(idx, grid.width)
        x = rem(idx, grid.width)
        {x, y}
      end
    )
  end

  def all_coords(grid) do
    indices = :array.sparse_to_orddict(grid.values)

    for {idx, _value} <- indices do
      y = div(idx, grid.width)
      x = rem(idx, grid.width)
      {x, y}
    end
  end

  def print_only_coords(grid, coords) do
    grid.values
    |> :array.to_list()
    |> Enum.chunk_every(grid.width, grid.width, :discard)
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
    indices = :array.sparse_to_orddict(grid.values)

    for {idx, ^char} <- indices do
      y = div(idx, grid.width)
      x = rem(idx, grid.width)
      {x, y}
    end
  end
end
