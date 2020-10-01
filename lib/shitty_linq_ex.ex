defmodule ShittyLinqEx do
  @moduledoc """
  Documentation for `ShittyLinqEx`.
  """
  
  #The sum() function
  
  @doc """
  Finds the sum of all values in a list with numeric elements.
  
  ##Examples
  
    iex> list = [1, 2, 3]
    iex> shittyLinqEx.sum(list)
    6
  """

  def sum([]) do
      0
  end
    
  def sum([h|t]) do
      h + sum(t)
  end
      
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
