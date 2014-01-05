# Episode 028: Parsing XML

In today's episode, we're going to look at how to parse XML.  Right now on EXPM
there are no packages listed that mention XML.  An advanced search on GitHub
shows no Elixir projects for XML parsing, though there are a few Erlang projects
for it.  For today, we're going to use the erlang `xmerl` module.  Let's get
started.

## Project
Go ahead and make a new project to play with this stuff in:

```shell
mix new xml_parsing && cd xml_parsing
```

Now let's open up the test file and start some test driven exploration of this
library.  Open up `test/xml_parsing_test.exs` and let's add some default XML to
parse:

```elixir
  def sample_xml do
    """
    <html>
      <head>
        <title>XML Parsing</title>
      </head>
      <body>
        <p>Neato</p>
        <ul>
          <li>First</li>
          <li>Second</li>
        </ul>
      </body>
    </html>
    """
  end
```

Now let's get to adding some tests.  First off, let's figure out how to just
parse this document and see what gets returned:

```elixir
  test "parsing the title out" do
    assert(:xmerl_scan.string(bitstring_to_list(sample_xml)) == :foo)
  end
```

This is an example of the sort of thing I might do when I want to explore
something and still feel good about it, rather than just fiddle in the console.
Tests are a great tool for this.  Now I know what the return value of an
`:xmerl_scan` looks like.

Next, let's try to grab the title out of the document.  To target an element, we
can use xpath via `:xmerl_xpath`.  Let's try it out:

```elixir
  test "parsing the title out" do
    { xml, _rest } = :xmerl_scan.string(bitstring_to_list(sample_xml))
    title = :xmerl_xpath.string('/html/head/title', xml)

    assert(title == "XML Parsing")
  end
```

So this is a bit closer - we can see the data we want, right there, but it's in
a weird tuple.  Turns out this is an xmlElement record.  However, erlang records
differ significantly from elixir records, and so we need to define a mapping
between them if we want to pattern match on them - and we do.

In order to define an Elixir record that is derived from an Erlang record, we
can use `Record.extract`.  At the top of the test file, we're going to define a
record so that we can pattern match.  Place this at the top of the test:

```elixir
defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
```

Again, this is how you can pull the `xmlElement` and `xmlText` records defined
in Erlang into the Elixir runtime, so that when those records are returned they
get parsed into Elixir records, rather than rather anonymous and scary-looking
tuples.

Now, another thing that we made a mistake in our first attempt with was that
`xmerl_xpath.string/2` returns a list of records, and so our `title` would just
be a list, rather than our expected `xmlElement`.  It's easy enough to fix this,
so let's wrap title in a list when we match it, and it will now contain the
`xmlElement`.

You can tell looking at [the `xmlElement` record](https://github.com/erlang/otp/blob/maint/lib/xmerl/include/xmerl.hrl#L73-L85)
that it has a `content` property that contains its subtree.  Let's extract the
`title_text` - which is just an `xmlText` node that the text inside the tag
parses into - from the content property.

Finally, we're left with an `xmlText` record, which has a `value` property, so
we can just call `title_text.value` in order to pull the value out of our title
text node.  Our finished code looks like this:

```elixir
  test "parsing the title out" do
    { xml, _rest } = :xmerl_scan.string(bitstring_to_list(sample_xml))
    [ title_element ] = :xmerl_xpath.string('/html/head/title', xml)
    [ title_text ] = title_element.content
    title = title_text.value

    assert(title == 'XML Parsing')
  end
```

So with that, we've learned how to handle some basic data extraction from XML.
Let's go ahead and look at what it would take to extract the other bits of
content from the body.  First, we'll get the p tag, but this time we'll use the
xpath `text()` function rather than go through the exterior p tag and then dig
manually into its text node:

```elixir
  test "parsing the p tag" do
    { xml, _rest } = :xmerl_scan.string(bitstring_to_list(sample_xml))
    [ p_text ] = :xmerl_xpath.string('/html/body/p/text()', xml)

    assert(p_text.value == 'Neato')
  end
```

Finally, let's map the `li` tags to a list of their text values:

```elixir
  test "parsing the li tags and mapping them" do
    { xml, _rest } = :xmerl_scan.string(bitstring_to_list(sample_xml))
    li_texts = :xmerl_xpath.string('/html/body/ul/li/text()', xml)
    texts = li_texts |> Enum.map(fn(x) -> x.value end)

    assert(texts == ['First', 'Second'])
  end
```

## Summary

In today's episode, we looked at some basic XML parsing techniques.  They're
easy enough to use, and it didn't take a great deal of effort.  There are also
ways to use xmerl as a SAX-style parser, which makes sense if you have rather
large XML documents.  The xmerl module is not particularly well-documented, so
your best bet is to find examples on github or in a blog post somewhere, if
you're interested in looking into SAX-style parsing - I've not yet dealt with
it.  Anyway, see you soon!

## Resources
- [xmerl user guide](http://www.erlang.org/doc/apps/xmerl/xmerl_ug.html)
- [xmerl manual](http://www.erlang.org/doc/man/xmerl_scan.html)
- [erlsom](https://github.com/willemdj/erlsom)
- [exml](https://github.com/paulgray/exml)
- [Differences between Erlang and Elixir records](http://elixir-lang.org/crash-course.html#notable_differences) - See the 'Records' section.
- [Dave Thomas on parsing XML in Erlang](http://pragdave.pragprog.com/pragdave/2007/04/a_first_erlang_.html)
- [`xmlElement` record](https://github.com/erlang/otp/blob/maint/lib/xmerl/include/xmerl.hrl#L73-L85)

