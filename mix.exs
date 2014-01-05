defmodule MarkdownServer.Mixfile do
  use Mix.Project

  def project do
    [ app: :markdown_server,
      version: "0.0.1",
      deps: deps,
      dialyzer: [paths: ["_build/shared/lib/markdown_server/ebin"]]
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [
        :cowboy,
        :ex_doc,
        :lager
      ],
      mod: { MarkdownServer, [] }
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      { :ex_doc, github: "elixir-lang/ex_doc" },
      { :cowboy, github: "extend/cowboy" },
      { :ibrowse, github: "cmullaparthi/ibrowse" },
      { :hackney,  github: "benoitc/hackney" },
      { :weber, github: "0xAX/weber" }
    ]
  end
end
