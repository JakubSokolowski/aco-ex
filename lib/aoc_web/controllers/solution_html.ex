defmodule AocWeb.SolutionHTML do
  use AocWeb, :html

  @doc """
  Renders a solution form.
  """
  attr :year, :integer, required: true
  attr :day, :integer, required: true
  slot :inner_block, required: true

  def solution_form(assigns) do
    ~H"""
    <.form for={%{part: "silver"}} action={~p"/#{@year}/#{@day}/solve"} phx-submit="solve">
      <.input
        type="select"
        name="part"
        label="Part"
        options={[{"Part 1", "silver"}, {"Part 2", "gold"}]}
        value={@part}
      />
      <%= render_slot(@inner_block) %>
    </.form>
    """
  end

  embed_templates "solution_html/*"
end
