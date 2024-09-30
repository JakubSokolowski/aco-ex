defmodule Aoc.Solver do
  require Logger

  @solutions_path "lib/aoc/solutions"

  @spec get_problem!(year :: integer, day :: integer) :: map
  def get_problem!(year, day) do
    %{
      year: year,
      day: day,
      code: "code",
      problem_url: "https://adventofcode.com/#{year}/day/#{day}",
      problem_input_url: "https://adventofcode.com/#{year}/day/#{day}/input"
    }
  end

  @spec solve_problem(year :: integer, day :: integer, part :: :silver | :gold) :: any
  def solve_problem(year, day, part) do
    input = fetch_input(year, day)
    solution = get_solution_module(year, day)

    case part do
      :silver -> solution.silver(input)
      :gold -> solution.gold(input)
    end
  end

  @spec get_solution_module(year :: integer, day :: integer) :: module
  def get_solution_module(year, day) do
    module_name = "Elixir.Aoc.Solutions.Year#{year}.Day#{pad_day(day)}"
    String.to_existing_atom(module_name)
  end

  @spec get_solution_source_code(year :: integer, day :: integer) :: String.t()
  def get_solution_source_code(year, day) do
    module = get_solution_module(year, day)
    Logger.info("Module: #{inspect(module)}")

    filename =
      module
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> Kernel.<>(".ex")

    path = Path.join([@solutions_path, "year#{year}", filename])

    Logger.info("Attempting to read module #{module} from #{path}")
    Logger.info("Path contents: #{inspect(File.ls(@solutions_path))}")

    case File.read(path) do
      {:ok, source_code} ->
        source_code

      {:error, reason} ->
        raise "Failed to read source file for #{inspect(module)}: #{reason}"
    end
  end

  @spec pad_day(integer) :: String.t()
  defp pad_day(day) do
    String.pad_leading("#{day}", 2, "0")
  end

  @spec get_input_file_path(year :: integer, day :: integer) :: String.t()
  def get_input_file_path(year, day) do
    padded_day = pad_day(day)

    Path.join([
      :code.priv_dir(:aoc),
      "static",
      "inputs",
      "#{year}",
      "day#{padded_day}.txt"
    ])
  end

  @spec fetch_input(year :: integer, day :: integer) :: String.t()
  def fetch_input(year, day) do
    padded_day = pad_day(day)
    file_path = get_input_file_path(year, day)

    case File.read(file_path) do
      {:ok, content} -> content
      {:error, _} -> raise "Failed to read input file for Year #{year}, Day #{padded_day}"
    end
  end
end
