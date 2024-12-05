defmodule AocWeb.SolutionLive do
  use AocWeb, :live_view
  alias Aoc.Solver

  def mount(%{"year" => year, "day" => day}, _session, socket) do
    year = String.to_integer(year)
    day = String.to_integer(day)

    problem = Solver.get_problem!(year, day)
    solution_code = Solver.get_solution_source_code(year, day)
    highlighted_code = AocWeb.SyntaxHighlighter.higlight("\n" <> solution_code, "elixir")
    input = Solver.fetch_input(year, day)

    {:ok,
     assign(socket,
       year: year,
       day: day,
       problem: problem,
       solution_code: highlighted_code,
       input: input,
       part: "silver",
       result: nil,
       solve_time: nil
     )}
  end

  def handle_event("solve", %{"part" => part}, socket) do
    start_time = System.monotonic_time(:millisecond)

    result =
      Solver.solve_problem(socket.assigns.year, socket.assigns.day, String.to_existing_atom(part))

    end_time = System.monotonic_time(:millisecond)
    solve_time = end_time - start_time

    {:noreply, assign(socket, result: result, part: part, solve_time: solve_time)}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <.back navigate={~p"/"}>All solutions</.back>
      <p class="text-zinc-900 dark:text-zinc-100 hover:text-zinc-700 dark:hover:text-zinc-300">
        Advent of Code <%= @year %> - Day <%= @day %>
      </p>
      <:subtitle>
        <.link
          href={@problem.problem_url}
          target="_blank"
          class="text-zinc-900 dark:text-zinc-100 hover:text-zinc-700 dark:hover:text-zinc-300"
        >
          Problem Description
        </.link>
        |
        <.link
          href={@problem.problem_input_url}
          target="_blank"
          class="text-zinc-900 dark:text-zinc-100 hover:text-zinc-700 dark:hover:text-zinc-300"
        >
          Download Input
        </.link>
      </:subtitle>
    </.header>

    <.form :let={_} for={%{}} as={:solution} phx-submit="solve">
      <div>
        <div class="flex items-end gap-x-4">
          <div>
            <.input
              type="select"
              name="part"
              value={@part}
              options={[{"Silver", "silver"}, {"Gold", "gold"}]}
            />
          </div>
          <div>
            <.button type="submit" phx-disable-with-delay={50} phx-disable-with="Solving...">
              Solve
            </.button>
          </div>
        </div>
      </div>
      <%= if @result do %>
        <div class="text-sm pt-4 space-y-2">
          <div class="text-gray-500 dark:text-gray-400">
            Result: <%= @result %>, Took <%= @solve_time %>ms
          </div>
        </div>
      <% end %>
      <div class="space-y-8 mt-4">
        <div class="border-b border-zinc-900/10 dark:border-zinc-600/10">
          <div class="overflow-x-auto">
            <pre class="highlight border-dashed whitespace-pre dark:bg-zinc-900 p-4 text-sm text-gray-500 dark:text-gray-400 rounded-md border border-zinc-200 dark:border-zinc-500">
              <%= @solution_code %>
            </pre>
          </div>
        </div>
      </div>
    </.form>
    """
  end
end
