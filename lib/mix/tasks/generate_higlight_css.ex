defmodule Mix.Tasks.GenerateHighlightCss do
  use Mix.Task

  @shortdoc "Generates CSS for syntax highlighting"
  def run(_) do
    css =
      Makeup.Styles.HTML.StyleMap.vim_style()
      |> Makeup.stylesheet()

    output_path = Path.join(["assets", "css", "highlight.css"])
    File.write!(output_path, css)
    Mix.shell().info("Generated highlight.css in #{output_path}")
  end
end
