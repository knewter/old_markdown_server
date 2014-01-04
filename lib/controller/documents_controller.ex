defmodule MarkdownServer.DocumentsController do
  def index([document: document], _conn) do
    rendered_document = MarkdownServer.Renderer.render("test/fixtures/#{document}.markdown")
    output = "<html><head><title>#{rendered_document.title}</title></head><body>#{rendered_document.body}</body></html>"
    {:text, output}
  end
end
