defmodule MarkdownServerTest do
  use ExUnit.Case

  setup do
    :hackney.start()
    :ok
  end

  test "serving up a directory of markdown files" do
    document = fetch_file("test_doc")
    assert Regex.match?(%r/This is a test document/, document)
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
