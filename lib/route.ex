defmodule Route do
  import Weber.Route
  require Weber.Route

  route on("GET", "/:document", :MarkdownServer.DocumentsController, :index)
end
