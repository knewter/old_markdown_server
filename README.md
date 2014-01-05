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

## License

This software is licensed under the MIT License.  See LICENSE for more
details.
