defmodule Mix.Tasks.GenerateHighlightCss do
  use Mix.Task

  @shortdoc "Generates CSS for syntax highlighting"
  def run(_) do
    css =
      Makeup.Styles.HTML.StyleMap.algol_style()
      |> Makeup.stylesheet()

    File.write!("priv/static/assets/highlight.css", css)
    Mix.shell().info("Generated highlight.css")
  end
end
