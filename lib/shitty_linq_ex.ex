defmodule ShittyLinqEx do
  @moduledoc """
  Documentation for `ShittyLinqEx`.
  """

  @doc """
  Determines whether all elements of a sequence satisfy a condition.

  ##Parameters
  - `list`: A list that contains the elements to apply the predicate to.
  - `funciton`: A function to test each element for a condition.

  ##Returns
  true if every element of the source sequence passes the test in the specified predicate, or if the sequence is empty; otherwise, false.

  ##Examples

    iex> import ShittyLinqEx, only: [all: 2]
    iex> all(
    ...>  ["Barley", "Boots", "Whiskers"],
    ...>  fn pet -> String.first(pet) == "B" end)
    false

    iex> import ShittyLinqEx, only: [all: 2]
    iex> all(
    ...>  [1, 3, 5, 7, 9],
    ...>  fn number -> rem(number,2) == 1 end)
    true
  """
  @spec all(list, fun) :: bool
  def all(list, predicate) when is_list(list) and is_function(predicate,1), do: do_all(list, predicate)
  defp do_all([], _predicate), do: true
  defp do_all([head | tail], predicate), do: predicate.(head) && do_all(tail, predicate)

  @doc """
  Inverts the order of the elements in a sequence.

  ## Parameters

  - `list`: A sequence of values to reverse.

  ## Returns
  A sequence whose elements correspond to those of the input sequence in reverse order.

  ## Examples

    iex> import ShittyLinqEx, only: [reverse: 1]
    iex> reverse(["A", "B", "C"])
    ["C", "B", "A"]

    iex> import ShittyLinqEx, only: [reverse: 1]
    iex> reverse([42, "orange", ":atom"])
    [":atom", "orange", 42]

  """

  @spec reverse(list) :: list
  def reverse(list) when is_list(list), do: reverse(list, [])
  def reverse([head | tail], acc), do: reverse(tail, [head | acc])
  def reverse([], acc), do: acc

  @doc """
  Filters a sequence of values based on a predicate.

  Where `source` is an enumerable to filter.
  Where `predicate` is a function to test each element for a condition.

  Returns an enumerable that contains elements from the input sequence that satisfy the condition.

  ## Examples

    iex> import ShittyLinqEx, only: [where: 2]
    iex> where(
    ...>  ["apple", "passionfruit", "banana", "mango", "orange", "blueberry", "grape", "strawberry"],
    ...>  fn fruit -> String.length(fruit) < 6 end)
    ["apple", "mango", "grape"]

    iex> import ShittyLinqEx, only: [where: 2]
    iex> where(
    ...>  [0, 30, 20, 15, 90, 85, 40, 75],
    ...>  fn number, index -> number <= index * 10 end)
    [0, 20, 15, 40]

  """
  def where(source, predicate) when is_list(source) and is_function(predicate, 1) do
    where_list(source, predicate)
  end

  def where(source, predicate) when is_list(source) and is_function(predicate, 2) do
    where_list(source, predicate, 0)
  end

  defp where_list([head | tail], fun) do
    case fun.(head) do
      true -> [head | where_list(tail, fun)]
      _ -> where_list(tail, fun)
    end
  end

  defp where_list([], _fun) do
    []
  end

  defp where_list([head | tail], fun, index) do
    case fun.(head, index) do
      true -> [head | where_list(tail, fun, index + 1)]
      _ -> where_list(tail, fun, index + 1)
    end
  end

  defp where_list([], _fun, _index) do
    []
  end
end
