defmodule Aoc.Solutions.Year2024.Day15 do
  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @impl true
  def silver(input) do
    [map, moves] = parse(input)
    robot = Grid.find_coords(map, "@") |> List.first()

    {new_map, _} =
      Enum.reduce(moves, {map, robot}, fn move, {acc_map, acc_robot} ->
        {updated_map, updated_robot} = move_robot(acc_map, acc_robot, move)
        {updated_map, updated_robot}
      end)

    boxes =
      Grid.find_coords(new_map, "O")

    boxes
    |> Enum.map(fn box ->
      coord = gps_coordinate(new_map, box)
      coord
    end)
    |> Enum.sum()
  end

  @impl true
  def gold(input) do
    wide = double(input)
    [map, moves] = parse(wide)

    robot = Grid.find_coords(map, "@") |> List.first()

    limited_moves =
      Enum.take(moves, 20)

    {new_map, _} =
      Enum.reduce(moves, {map, robot}, fn move, {acc_map, acc_robot} ->
        {before_x, before_y} = acc_robot
        {updated_map, updated_robot} = move_robot_wide(acc_map, acc_robot, move)
        {after_x, after_y} = updated_robot
        {updated_map, updated_robot}
      end)

    boxes =
      Grid.find_coords(new_map, "[")

    boxes
    |> Enum.map(fn box ->
      coord = gps_coordinate(new_map, box)
      coord
    end)
    |> Enum.sum()
  end

  def gps_coordinate(map, box) do
    {x, y} = box
    y * 100 + x
  end

  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> then(fn [map, moves] ->
      [
        Grid.parse(map),
        moves
        |> String.replace(~r/[^\^v<>]/, "")
        |> String.graphemes()
      ]
    end)
  end

  def double(input) do
    input
    |> String.graphemes()
    |> Enum.map(fn char ->
      case char do
        "#" -> "##"
        "O" -> "[]"
        "." -> ".."
        "@" -> "@."
        _ -> char
      end
    end)
    |> Enum.join()
  end

  def next_pos({x, y}, move) do
    case move do
      "^" -> {x, y - 1}
      "v" -> {x, y + 1}
      "<" -> {x - 1, y}
      ">" -> {x + 1, y}
    end
  end

  def move_robot(map, robot, move) do
    next = next_pos(robot, move)

    case Grid.element_at(map, next) do
      "." ->
        new_grid = Grid.swap_points(map, robot, next)
        {new_grid, next}

      "#" ->
        {map, robot}

      "O" ->
        # get all boxes in line, until we hit a wall or empty space
        boxes = get_boxes_in_line(map, robot, move)

        # If we hit a wall, return the same grid
        case Grid.element_at(map, next_pos(List.last(boxes), move)) do
          "#" ->
            {map, robot}

          _ ->
            new_grid =
              Enum.reduce(boxes |> Enum.reverse(), map, fn box, acc ->
                Grid.swap_points(acc, box, next_pos(box, move))
              end)

            {Grid.swap_points(new_grid, robot, next), next}
        end
    end
  end

  def move_robot_wide(map, robot, move) do
    next_pos = next_pos(robot, move)
    next_value = Grid.element_at(map, next_pos)

    case next_value do
      "." ->
        new_grid = Grid.swap_points(map, robot, next_pos)
        {new_grid, next_pos}

      "#" ->
        {map, robot}

      _ ->
        move_rows(map, robot, move)
    end
  end

  def move_rows(map, robot, move) do
    case move do
      "^" -> move_vertical(map, robot, move)
      "v" -> move_vertical(map, robot, move)
      "<" -> move_horizontal(map, robot, move)
      ">" -> move_horizontal(map, robot, move)
    end
  end

  def move_horizontal(map, robot, move) do
    {x, y} = robot
    boxes = get_wide_boxes_in_line(map, robot, move)

    groups = group_y(boxes, move)

    idx = 0

    {_y, last_group} = Enum.at(groups, idx)

    next = next_pos(robot, move)

    if can_move(map, last_group, move) do
      updated =
        groups
        |> Enum.reduce(map, fn {_y, boxes}, acc ->
          move_row(acc, boxes, move)
        end)

      {Grid.swap_points(updated, robot, next), next}
    else
      {map, robot}
    end
  end

  def move_vertical(map, robot, move) do
    {x, y} = robot
    boxes = get_wide_boxes_in_line(map, robot, move)
    groups = group_y(boxes, move)

    {_y, last_group} = Enum.at(groups, 0)

    next = next_pos(robot, move)

    all_groups_can_move = Enum.all?(groups, fn {_, boxes} -> can_move(map, boxes, move) end)

    if all_groups_can_move do
      updated =
        groups
        |> Enum.reduce(map, fn {_y, boxes}, acc ->
          move_row(acc, boxes, move)
        end)

      {Grid.swap_points(updated, robot, next), next}
    else
      {map, robot}
    end
  end

  def can_move(map, last_box_row, move) do
    last_box_row
    |> Enum.all?(fn box ->
      next = next_pos(box, move)
      Grid.element_at(map, next) != "#"
    end)
  end

  def move_row(map, box_row, move) do
    sorted =
      case move do
        "<" ->
          box_row = Enum.sort_by(box_row, fn {x, _} -> x end)

        ">" ->
          box_row = Enum.sort_by(box_row, fn {x, _} -> x end, :desc)

        _ ->
          box_row
      end

    Enum.reduce(sorted, map, fn box, acc ->
      Grid.swap_points(acc, box, next_pos(box, move))
    end)
  end

  def get_wide_boxes_in_line(map, robot, move) do
    next = next_pos(robot, move)

    # if horizontal, check only next in line
    #
    # if vertical:
    #  - [ -> check also right
    #  - ] -> check also left

    next_tile = Grid.element_at(map, next)

    horizontal = move in ["<", ">"]

    cond do
      horizontal ->
        case next_tile do
          "[" -> [next | get_wide_boxes_in_line(map, next, move)]
          "]" -> [next | get_wide_boxes_in_line(map, next, move)]
          _ -> []
        end

      true ->
        case next_tile do
          # if [ include also the tile to the right
          "[" ->
            [next | get_wide_boxes_in_line(map, next, move)] ++
              [next_pos(next, ">") | get_wide_boxes_in_line(map, next_pos(next, ">"), move)]

          "]" ->
            [next | get_wide_boxes_in_line(map, next, move)] ++
              [next_pos(next, "<") | get_wide_boxes_in_line(map, next_pos(next, "<"), move)]

          _ ->
            []
        end
    end
  end

  def group_y(boxes, move) do
    sort_direction =
      case move do
        "^" -> :asc
        "v" -> :desc
        _ -> :asc
      end

    boxes
    |> Enum.uniq()
    |> Enum.group_by(fn {_x, y} -> y end)
    |> Enum.sort_by(fn {y, _coords} -> y end, sort_direction)
  end

  def get_boxes_in_line(map, robot, move) do
    next = next_pos(robot, move)

    case Grid.element_at(map, next) do
      "O" -> [next | get_boxes_in_line(map, next, move)]
      _ -> []
    end
  end
end
