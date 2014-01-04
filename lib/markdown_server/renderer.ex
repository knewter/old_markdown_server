defmodule MarkdownServer.Renderer do

  @moduledoc """
  MarkdownServer.Renderer is used to transform a file or string containing
  markdown into a MarkdownServer.RenderedDocument.

  It will extract a title from the rendered html and set that as the
  RenderedDocument's title, or it will set it to "Untitled Document".

  For example:

      iex> MarkdownServer.Renderer.render_string("seriously")
      MarkdownServer.RenderedDocument[body: "<p>seriously</p>", title: "Untitled Document"]
  """

  alias MarkdownServer.RenderedDocument

  @doc """
  Given the path to a markdown file, returns a RenderedDocument representing the
  contents of the file.
  """
  @spec render(binary()) :: MarkdownServer.RenderedDocument.new
  def render(file_path) when is_binary(file_path) do
    File.read!(file_path) |> render_string
  end

  @doc """
  Given a string containing markdown, returns a RenderedDocument representing
  the contents of the string.
  """
  @spec render_string(binary()) :: MarkdownServer.RenderedDocument.new
  def render_string(string) when is_binary(string) do
    body = string |> Markdown.to_html
    body = Regex.replace(%r/\n/, body, "")
    title = title_for(body)
    RenderedDocument[body: body, title: title]
  end

  defp title_matcher do
    %r/<h1>(?<title>.*)<\/h1>/g
  end

  defp title_for(body) do
    case Regex.named_captures(title_matcher, body) do
      [title: title] -> title
      nil -> "Untitled Document"
    end
  end
end

