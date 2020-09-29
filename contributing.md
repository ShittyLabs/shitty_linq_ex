# Contributing to ShittyLinqEx

1. Read the [Code of Conduct](./code_of_conduct.md)
1. If adding a new method, follow the [new method instructions](#adding-a-new-method)

## Adding a new method

1. If an issue exists for this method, add a comment to let everyone know that you are implementing it. This helps us avoid duplicates.
1. Fork the repo if you haven't done so already.
1. Create a branch from an up-to-date `master` branch.
1. Implement the method in the `./lib/shitty_linq_ex.ex` file (alphabetical order, then by cardinality)
   - _Note: Please try to implement the method signature as close to the original C# LINQ method signature as possible._
   - _Since this is the shitty version of LINQ, avoid adding new libraries and using other modules (you are more than welcome to use the `ShittyLinqEx` module)_
1. Document the method using standard [Elixir documentation syntax](https://hexdocs.pm/elixir/writing-documentation.html).
1. [Add tests](#add-tests).
1. Push branch to your fork.
1. Create a pull request against the `master` branch of the main repo.

## Add tests

1. [Add Doctests to your documentation](https://hexdocs.pm/elixir/writing-documentation.html#doctests)
1. Add tests for success conditions.
1. Add tests for failure conditions according to the MDN documents for the method you are adding. Ensure the proper errors are thrown.
