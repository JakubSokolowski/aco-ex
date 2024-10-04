defmodule AocWeb.SyntaxHighlighter do
  def higlight(code, language) do
    lexer = get_lexer(language)

    code
    |> Makeup.highlight_inner_html(lexer: lexer, formatter_opts: [css_class: "highlight"])
    |> Phoenix.HTML.raw()
  end

  defp get_lexer("elixir"), do: Makeup.Lexers.ElixirLexer
  defp get_lexer(_), do: Makeup.Lexers.ElixirLexer
end
