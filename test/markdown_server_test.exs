defmodule MarkdownServerTest do
  use ExUnit.Case

  setup do
    :hackney.start()
    :ok
  end

  test "serving up a directory of markdown files" do
    document = fetch_file("test_doc")
    expected_document = "<html><head><title>This is a test document</title></head><body><h1>This is a test document</h1><p>It has a <a href=\"http://elixirsips.com\">link</a>.</p></body></html>"
    assert expected_document == document
  end

  def fetch_file(path) do
    {:ok, 200, _headers, client} = :hackney.request(:get, url_for(path))
    {:ok, body} = :hackney.body(client)
    body
  end

  def url_for(path) do
    "http://localhost:9913/#{path}"
  end
end
