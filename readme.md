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

## Contributing

Please see our [Code of Conduct](./code-of-conduct.md) and [Contributing](./contributing.md) guide before beginning.

Below is an example of what adding a new method should look like.

```elixir
@doc"""
Calculates the value of the nth Fibonacci number.

## Examples

  iex> Enum.map(0..5, &fib/1)
  [1, 1, 2, 3, 5, 8]

"""
def fib(0), do: 1
def fib(1), do: 1
def fib(n), do: fib(1, 1, n)

defp fib(last, _prev, 1), do: last
defp fib(last, prev, n), do: fib(last + prev, last, n - 1)
```
