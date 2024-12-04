defmodule Aoc.Solutions.Grid do
  defstruct [
    :values,
    :width,
    :height
  ]

  @directions [
    # right
    {0, 1},
    # down
    {1, 0},
    # diagonal down-right
    {1, 1},
    # diagonal down-left
    {1, -1},
    # left
    {0, -1},
    # up
    {-1, 0},
    # diagonal up-left
    {-1, -1},
    # diagonal up-right
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

    dbg(%{rows: rows, width: width, height: height})

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

  def find_word_lines(grid, {x, y}, word, directions) do
    directions
    |> Enum.map(fn {dx, dy} ->
      {coords, line} = get_line(grid, {x, y}, {dx, dy}, String.length(word) - 1)

      %{
        start: {x, y},
        delta: {dx, dy},
        coords: coords,
        line: line
      }
    end)
    |> Enum.filter(fn res ->
      res[:line] == String.graphemes(word)
    end)
  end

  def count_word(grid, word) do
    first_char = String.at(word, 0)
    coords = find_coords(grid, first_char)

    all_lines =
      coords |> Enum.map(fn {x, y} -> find_word_lines(grid, {x, y}, word, @directions) end)

    all_lines
    |> Enum.map(fn lines -> Enum.count(lines) end)
    |> Enum.sum()
  end

  def count_x_mases(grid) do
    a_coords = find_coords(grid, "M")

    directions = [
      # diagonal down-right
      {1, 1},
      # diagonal down-left
      {1, -1},
      # diagonal up-left
      {-1, -1},
      # diagonal up-right
      {-1, 1}
    ]

    mas_lines =
      a_coords
      |> Enum.map(fn {x, y} -> find_word_lines(grid, {x, y}, "MAS", directions) end)

    flat_lines = mas_lines |> List.flatten()

    dbg(flat_lines)

    middle_points =
      flat_lines
      |> Enum.map(fn line -> Enum.at(line[:coords], 1) end)

    dbg(middle_points)

    freqs =
      middle_points
      |> Enum.frequencies()

    overlapping =
      freqs
      |> Enum.filter(fn {_, count} -> count > 1 end)
      |> Enum.map(fn {point, _} -> point end)

    dbg(overlapping)

    x_masses =
      flat_lines
      |> Enum.filter(fn line -> Enum.member?(overlapping, Enum.at(line[:coords], 1)) end)

    dbg(x_masses)

    all_xmass_coords = x_masses |> Enum.map(fn line -> line[:coords] end) |> List.flatten()

    print_only_coords(grid, all_xmass_coords)

    div(Enum.count(x_masses), 2)
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
