# Kaitai Struct: Runtime library for Elixir

[![CI Status](https://img.shields.io/github/actions/workflow/status/polymorfiq/kaitai_struct_ex/elixir.yml)](https://github.com/polymorfiq/kaitai_struct_ex/actions/workflows/elixir.yml)
[![Hex Package](https://img.shields.io/hexpm/v/kaitai_struct)](https://hex.pm/packages/kaitai_struct)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/kaitai_struct/)
[![MIT License](https://img.shields.io/hexpm/l/kaitai_struct)](https://choosealicense.com/licenses/mit/)

Kaitai Struct is a declarative language used for describe various binary data structures, laid out in files or in memory: i.e. binary file formats, network stream packet formats, etc.

Further reading:

- [About Kaitai Struct](https://kaitai.io/)
- [About API implemented in this library](https://doc.kaitai.io/stream_api.html)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kaitai_struct` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kaitai_struct, "~> 0.2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kaitai_struct>.

