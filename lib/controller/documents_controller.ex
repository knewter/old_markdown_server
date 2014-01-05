defmodule MarkdownServer.DocumentsController do
  use Weber.Controller

  layout "Application.html"

  def index([document: document], _conn) do
    rendered_document = MarkdownServer.Renderer.render("test/fixtures/#{document}.markdown")
    {:render, [body: rendered_document.body, title: rendered_document.title]}
  end
end
