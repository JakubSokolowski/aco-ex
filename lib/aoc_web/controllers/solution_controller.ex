defmodule AocWeb.SolutionController do
  use AocWeb, :controller
  alias Aoc.Solver

  def show(conn, %{"year" => year, "day" => day}) do
    year = String.to_integer(year)
    day = String.to_integer(day)

    problem = Solver.get_problem!(year, day)
    solution_code = Solver.get_solution_source_code(year, day)
    highlighted_code = AocWeb.SyntaxHighlighter.higlight(solution_code, "elixir")
    input = Solver.fetch_input(year, day)

    render(conn, :show,
      year: year,
      day: day,
      problem: problem,
      solution_code: highlighted_code,
      input: input,
      part: "silver"
    )
  end

  def solve(conn, %{"year" => year, "day" => day, "part" => part}) do
    year = String.to_integer(year)
    day = String.to_integer(day)
    result = Solver.solve_problem(year, day, String.to_existing_atom(part))
    json(conn, %{result: result})
  end
end
