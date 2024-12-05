defmodule AocWeb.Component.NavLink do
  @moduledoc """
  Navigation link component that provides consistent styling and active state indication.
  Supports external links with a special indicator icon.
  """
  use AocWeb, :html

  @doc """
  Renders a navigation link with consistent styling and active state.

  ## Attributes
    * `active` - Indicates if the link represents the current page/section
    * `link` - The URL or path to navigate to
    * `icon` - Optional hero icon name to display
    * `external` - Whether the link points to an external resource
    * `inner_block` - The content/text of the link

  ## Examples
      <.nav_link
        active={current_section == :features}
        link={~p"/some/path"}
        icon="hero-flag"
      >
        Link Text
      </.nav_link>

      <.nav_link
        active={current_section == :features}
        link={~p"/some/path"}
      >
        Link Text without Icon
      </.nav_link>
  """
  @spec nav_link(map()) :: Phoenix.LiveView.Rendered.t()
  attr :active, :boolean, default: false
  attr :link, :string, required: true
  attr :icon, :string, default: nil
  attr :external, :boolean, default: false
  slot :inner_block, required: true

  def nav_link(assigns) do
    ~H"""
    <.link
      navigate={@link}
      class={[
        "flex items-center px-6 py-3 text-sm font-medium group",
        @active && "bg-zinc-100 dark:bg-zinc-900 rounded-xl"
      ]}
    >
      <span
        :if={@icon}
        class={[
          "mr-3",
          "text-zinc-500 dark:text-zinc-400 transition-colors duration-200",
          "group-hover:text-zinc-900 dark:group-hover:text-zinc-100",
          @active && "text-brand"
        ]}
      >
        <.icon name={@icon} class="h-5 w-5" />
      </span>
      <span class={[
        "text-zinc-500 dark:text-zinc-400 transition-colors duration-200",
        "group-hover:text-zinc-900 dark:group-hover:text-zinc-100",
        @active && "text-brand dark:text-brand",
        "flex-1"
      ]}>
        <%= render_slot(@inner_block) %>
      </span>
      <span
        :if={@external}
        class={[
          "transition-all duration-200 transform",
          "opacity-0 -translate-x-2 scale-95 group-hover:opacity-100 group-hover:translate-x-0 group-hover:scale-100",
          "ml-2 flex items-center text-zinc-400 group-hover:text-zinc-600 dark:group-hover:text-zinc-300"
        ]}
      >
        <.icon name="hero-arrow-top-right-on-square-mini" class="h-4 w-4" />
      </span>
    </.link>
    """
  end

  @doc """
  Creates a separator line in the navigation menu.
  """
  attr :class, :string, default: nil

  def nav_separator(assigns) do
    ~H"""
    <div class={[
      "my-2 border-t border-zinc-200 dark:border-zinc-700",
      @class
    ]} />
    """
  end
end
