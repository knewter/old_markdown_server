defmodule MarkdownServer.RendererTest do
  use ExUnit.Case
  doctest MarkdownServer.Renderer

  test "renders markdown documents, extracting the first h1 as their title" do
    rendered_document = MarkdownServer.Renderer.render("./test/fixtures/test_doc.markdown")
    expected_body = "<h1>This is a test document</h1>\n\n<p>It has a <a href=\"http://elixirsips.com\">link</a>.</p>\n"
    expected_title = "This is a test document"
    assert MarkdownServer.RenderedDocument[title: expected_title, body: expected_body] == rendered_document
  end

  test "renders markdown documents, filling in title as untitled document if no h1" do
    rendered_document = MarkdownServer.Renderer.render("./test/fixtures/test_doc_no_title.markdown")
    expected_body = "<p>This doc has no title.</p>\n"
    expected_title = "Untitled Document"
    assert MarkdownServer.RenderedDocument[title: expected_title, body: expected_body] == rendered_document
  end
end
