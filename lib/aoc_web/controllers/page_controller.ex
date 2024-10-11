defmodule AocWeb.PageController do
  use AocWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    solutions = [
      %{year: 2020, days: [1, 2, 3, 4]}
    ]

    render(conn, :home, layout: false, solutions: solutions)
  end
end
