defmodule Aoc.Solutions.Year2024.Day16 do
  @behaviour Aoc.Solution

  alias Aoc.Solutions.Grid

  @directions [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

  @impl true
  def silver(input) do
    map = Grid.parse(input)
    start = Grid.find_coords(map, "S") |> List.first()
    target = Grid.find_coords(map, "E") |> List.first()

    case find_all_best_paths(map, start, target) do
      :no_path -> "No path found"
      {cost, _, _} -> cost
    end
  end

  def find_all_best_paths(map, start, target) do
    initial_queue = :gb_sets.from_list([{0, start, {0, 1}, [start]}])

    state_costs = %{}
    state_paths = %{}

    find_paths_recursive(map, target, initial_queue, state_costs, state_paths, [], :infinity)
  end

  defp find_paths_recursive(map, target, queue, state_costs, state_paths, best_paths, min_cost)
       when min_cost != :infinity do
    cond do
      :gb_sets.is_empty(queue) ->
        {min_cost, best_paths, all_tiles_in_paths(best_paths)}

      true ->
        {{cost, _pos, _dir, _path}, _rest} = :gb_sets.take_smallest(queue)

        if cost > min_cost do
          {min_cost, best_paths, all_tiles_in_paths(best_paths)}
        else
          find_paths_next_state(
            map,
            target,
            queue,
            state_costs,
            state_paths,
            best_paths,
            min_cost
          )
        end
    end
  end

  defp find_paths_recursive(map, target, queue, state_costs, state_paths, best_paths, min_cost) do
    if :gb_sets.is_empty(queue) do
      :no_path
    else
      find_paths_next_state(map, target, queue, state_costs, state_paths, best_paths, min_cost)
    end
  end

  defp find_paths_next_state(map, target, queue, state_costs, state_paths, best_paths, min_cost) do
    {{cost, pos, dir, path}, rest} = :gb_sets.take_smallest(queue)

    cond do
      pos == target ->
        new_min_cost = cost
        new_best_paths = [path | best_paths]

        find_paths_recursive(
          map,
          target,
          rest,
          state_costs,
          state_paths,
          new_best_paths,
          new_min_cost
        )

      true ->
        neighbors = get_valid_neighbors(map, pos)
        state = {pos, dir}

        {new_queue, new_state_costs, new_state_paths} =
          process_neighbors(neighbors, pos, dir, cost, path, rest, state_costs, state_paths)

        find_paths_recursive(
          map,
          target,
          new_queue,
          new_state_costs,
          new_state_paths,
          best_paths,
          min_cost
        )
    end
  end

  defp process_neighbors(
         neighbors,
         current_pos,
         current_dir,
         current_cost,
         current_path,
         queue,
         state_costs,
         state_paths
       ) do
    Enum.reduce(neighbors, {queue, state_costs, state_paths}, fn next_pos, {q, costs, paths} ->
      if next_pos not in current_path do
        new_dir = get_direction(current_pos, next_pos)
        new_cost = current_cost + 1 + if(new_dir == current_dir, do: 0, else: 1000)
        new_state = {next_pos, new_dir}
        new_path = current_path ++ [next_pos]

        current_cost = Map.get(costs, new_state, :infinity)

        cond do
          new_cost < current_cost ->
            new_q = :gb_sets.add_element({new_cost, next_pos, new_dir, new_path}, q)
            new_costs = Map.put(costs, new_state, new_cost)
            new_paths = Map.put(paths, new_state, [new_path])
            {new_q, new_costs, new_paths}

          new_cost == current_cost ->
            new_q = :gb_sets.add_element({new_cost, next_pos, new_dir, new_path}, q)
            new_paths = Map.update(paths, new_state, [new_path], &[new_path | &1])
            {new_q, costs, new_paths}

          true ->
            {q, costs, paths}
        end
      else
        {q, costs, paths}
      end
    end)
  end

  defp get_valid_neighbors(map, {x, y}) do
    @directions
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(&Grid.in_bounds?(map, &1))
    |> Enum.filter(&(Grid.element_at(map, &1) != "#"))
  end

  defp get_direction({x1, y1}, {x2, y2}) do
    {x2 - x1, y2 - y1}
  end

  defp all_tiles_in_paths(paths) do
    paths
    |> Enum.flat_map(& &1)
    |> MapSet.new()
  end

  @impl true
  def gold(input) do
    map = Grid.parse(input)
    start = Grid.find_coords(map, "S") |> List.first()
    target = Grid.find_coords(map, "E") |> List.first()

    case find_all_best_paths(map, start, target) do
      :no_path -> "No path found"
      {cost, _, tiles} -> Enum.count(tiles)
    end
  end
end
