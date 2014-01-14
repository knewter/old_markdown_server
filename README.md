# MarkdownServer

[![Build Status](https://travis-ci.org/knewter/markdown_server.png)](https://travis-ci.org/knewter/markdown_server)

This will serve markdown files from a given directory, parsing them to HTML.

It should support livereload as well.

## Usage

```sh
mix run scripts/serve_directory ~/Documents/markdown_docs
```

## CSS

The CSS we use is built using sass.  Edit the files in `sass/` and run `compass
watch`, and the public/stylesheets files will be generated.

## Building a release

To build a release, just run:

```sh
mix relex.assemble
```

To run a release, run:

```sh
MARKDOWN_DIR=~/Dropbox/ElixirSips/028_Parsing_XML ./releases/markdown_server/erts-5.10.4/bin/erl --boot ./releases/markdown_server/releases/0.0.1/markdown_server
```

## License

This software is licensed under the MIT License.  See LICENSE for more
details.
