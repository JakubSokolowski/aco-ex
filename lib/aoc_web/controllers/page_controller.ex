defmodule AocWeb.PageController do
  use AocWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    solutions = [
      %{year: 2020, day: 1},
      %{year: 2020, day: 2},
      %{year: 2020, day: 3}
    ]

    render(conn, :home, layout: false, solutions: solutions)
  end
end
