# ShittyLinqEx

> The _shitty_ version of the LINQ-to-objects Enumerable extension methods for Elixir.

## What this is

A set of methods mirroring the [`System.Linq`](https://docs.microsoft.com/en-us/dotnet/csharp/linq/) namespace from C#.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `shitty_linq_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:shitty_linq_ex, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
import ShittyLinqEx, only: [where: 2, take: 2, aggregate: 2]

[2, 9, 1, 7, 4]
|> where(fn x -> rem(x, 2) != 0 end)
|> take(2)
|> aggregate(fn (a, b) -> a + b end)
// <- 10
```
