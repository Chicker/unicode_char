# Unicode.Char

In this library are implemented functions (Char.lower?, Char.digit?, etc) to work with Unicode characters, which are is missing in the stdlib.

## Installation

Add `unicode_char` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:unicode_char, "~> 0.6.0"}]
end
```

## Implemented functions

* lower?
* upper?
* digit?
* control?
* whitespace?
* and so on.

## Using

```elixir
defmodule MyModule do
  alias Unicode.Char # for convenience
  
  if Char.upper?("È") do
    # do something with upper case letter
  else
    # otherwise
  end
end
```
