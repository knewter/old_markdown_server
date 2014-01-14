defmodule MarkdownServer.DocumentsController do
  use Weber.Controller

  layout "Application.html"

  def index([document: document], _conn) do
    IO.inspect file_path(document)
    rendered_document = file_path(document) |> MarkdownServer.Renderer.render
    {:render, [body: rendered_document.body, title: rendered_document.title]}
  end

  def file_path(document) do
    "#{base_dir}/#{document}.markdown"
  end

  defp base_dir do
    System.get_env("MARKDOWN_DIR")
  end
end
