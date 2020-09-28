defmodule ShittyLinqEx do
  @moduledoc """
  Documentation for `ShittyLinqEx`.
  """

  @doc """
  Filters a sequence of values based on a predicate.

  Where `source` is an enumerable to filter.
  Where `predicate` is a function to test each element for a condition.

  Returns an enumerable that contains elements from the input sequence that satisfy the condition.

  ## Examples

    iex> import ShittyLinqEx, only: [where: 2]
    iex> where([1, 2, 3], fn x -> rem(x, 2) == 0 end)
    [2]

  """
  def where(source, predicate) when is_list(source) do
    where_list(source, predicate)
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
end
