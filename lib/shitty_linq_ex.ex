defmodule ShittyLinqEx do
  @moduledoc """
  Documentation for `ShittyLinqEx`.
  """

  @doc """
  Applies an accumulator function over a sequence. The specified seed value is used as the initial
  accumulator value, and the specified function is used to select the result value.
  ## Parameters
  - `source`: an enumerable to aggregate over.
  - `seed`: the initial accumulator value.
  - `func`: an accumulator function to be invoked on each element.
  - `resultSelector`: a function to transform the final accumulator value into the result value.
  ## Returns
  The transformed final accumulator value.
  ## Examples
    iex> import ShittyLinqEx, only: [aggregate: 4]
    iex> fruits = ["apple", "mango", "orange", "passionfruit", "grape"]
    iex> aggregate(
    ...>  fruits,
    ...>  "banana",
    ...>  fn next, longest ->
    ...>    if String.length(next) > String.length(longest) do
    ...>      next
    ...>    else
    ...>      longest
    ...>    end
    ...>  end,
    ...>  &String.upcase/1)
    "PASSIONFRUIT"
  """
  def aggregate(source, seed, func, resultSelector)
      when is_list(source) and is_function(func, 2) and is_function(resultSelector, 1) do
    :lists.foldl(func, seed, source)
    |> resultSelector.()
  end

  def aggregate(first..last, seed, func, resultSelector)
      when is_function(func, 2) and is_function(resultSelector, 1) do
    if first <= last do
      aggregate_range_inc(first, last, seed, func)
    else
      aggregate_range_dec(first, last, seed, func)
    end
    |> resultSelector.()
  end

  def aggregate(%{} = source, seed, func, resultSelector)
      when is_function(func, 2) and is_function(resultSelector, 1) do
    :maps.fold(
      fn key, value, accumulator -> func.({key, value}, accumulator) end,
      seed,
      source
    )
    |> resultSelector.()
  end

  def aggregate(source, seed, func, resultSelector)
      when is_list(source) and is_function(func, 2) and is_function(resultSelector, 1) do
    :lists.foldl(func, seed, source)
    |> resultSelector.()
  end

  def aggregate(first..last, seed, func, resultSelector)
      when is_function(func, 2) and is_function(resultSelector, 1) do
    if first <= last do
      aggregate_range_inc(first, last, seed, func)
    else
      aggregate_range_dec(first, last, seed, func)
    end
    |> resultSelector.()
  end

  @doc """
  Applies an accumulator function over a sequence.
  The specified seed value is used as the initial accumulator value.
  ## Parameters
  - `source`: an enumerable to aggregate over.
  - `seed`: the initial accumulator value.
  - `func`: an accumulator function to be invoked on each element.
  ## Returns
  The final accumulator value.
  ## Examples
    iex> import ShittyLinqEx, only: [aggregate: 3]
    iex> ints = [4, 8, 8, 3, 9, 0, 7, 8, 2]
    iex> aggregate(
    ...>  ints,
    ...>  0,
    ...>  fn next, total ->
    ...>    if rem(next, 2) == 0 do
    ...>      total + 1
    ...>    else
    ...>      total
    ...>    end
    ...>  end)
    6
    iex> import ShittyLinqEx, only: [aggregate: 3]
    iex> aggregate(4..1, 1, &*/2)
    24
    iex> import ShittyLinqEx, only: [aggregate: 3]
    iex> aggregate(1..3, 1, &+/2)
    7
    iex> import ShittyLinqEx, only: [aggregate: 3]
    iex> letters_to_numbers = %{a: 1, b: 2, c: 3}
    iex> aggregate(
    ...>  letters_to_numbers,
    ...>  [],
    ...>  fn {key, _value}, keys -> [key | keys] end)
    [:c, :b, :a]
  """
  def aggregate(source, seed, func)
      when is_list(source) and is_function(func, 2) do
    :lists.foldl(func, seed, source)
  end

  def aggregate(first..last, seed, func)
      when is_function(func, 2) do
    if first <= last do
      aggregate_range_inc(first, last, seed, func)
    else
      aggregate_range_dec(first, last, seed, func)
    end
  end

  def aggregate(%{} = source, seed, func)
      when is_function(func, 2) do
    :maps.fold(
      fn key, value, acc -> func.({key, value}, acc) end,
      seed,
      source
    )
  end

  @doc """
  Applies an accumulator function over a sequence.
  ## Parameters
  - `source`: an enumerable to aggregate over.
  - `func`: an accumulator function to be invoked on each element.
  ## Returns
  The final accumulator value.
  ## Examples
  iex> import ShittyLinqEx, only: [aggregate: 2]
  iex> sentence = "the quick brown fox jumps over the lazy dog"
  iex> words = String.split(sentence)
  iex> aggregate(
  ...>  words,
  ...>  fn word, workingSentence -> word <> " " <> workingSentence end)
  "dog lazy the over jumps fox brown quick the"
  """
  def aggregate([head | tail], func)
      when is_function(func, 2) do
    aggregate(tail, head, func)
  end

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
  Returns the first element of a sequence.
  ## Parameters
  - `list`: A sequence of values of which the first element should be returned.
  - `predicate`: A function to check for each element
  - `value`: A value which will be checked in the predicate function
  ## Returns
  First value of the input sequence.
  ## Examples
    iex> import ShittyLinqEx, only: [first: 1]
    iex> first(["A", "B", "C"])
    "A"
    iex> import ShittyLinqEx, only: [first: 1]
    iex> first([42, "orange", ":atom"])
    42
    iex> import ShittyLinqEx, only: [first: 3]
    iex> first([4, 2, 3], &>/2, 1)
    4
  """

  def first(list) when is_list(list), do: List.first(list)
  def first([]), do: nil
  def first(nil), do: nil

  def first([head | tail], func, value) when is_list(tail) and is_function(func, 2) do
    case func.(head, value) do
      true -> head
      false -> first(tail, func, value)
    end
  end

  def first([], _func, _value), do: nil

  @doc """
  Returns a specified number of contiguous elements from the start of a sequence.

  ## Parameters

  - `source`: A sequence of values to take.
  - `count`: The number of elements to return.

  ## Returns

  A sequence that contains the specified number of elements from the start of the input sequence.

  ## Examples

    iex> import ShittyLinqEx, only: [take: 2]
    iex> take(["A", "B", "C"], 2)
    ["A", "B"]

    iex> import ShittyLinqEx, only: [take: 2]
    iex> take([42, "orange", ":atom"], 7)
    [42, "orange", ":atom"]

    iex> import ShittyLinqEx, only: [take: 2]
    iex> take([1, 2, 3], 0)
    []

    iex> import ShittyLinqEx, only: [take: 2]
    iex> take(nil, 5)
    nil

  """

  def take(_source, 0), do: []
  def take(_souce, count) when is_integer(count) and count < 0, do: []
  def take(nil, _count), do: nil
  def take([], _count), do: []

  def take(source, count)
      when is_list(source) and is_integer(count) and count > 0 do
    take_list(source, count)
  end

  @doc """
  Filters a sequence of values based on a predicate.
  ## Parameters
  - `source`: an enumerable to filter.
  - `predicate`: a function to test each element for a condition.
  ## Returns
  An enumerable that contains elements from the input sequence that satisfy the condition.
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

  defp aggregate_range_inc(first, first, seed, func) do
    func.(first, seed)
  end

  defp aggregate_range_inc(first, last, seed, func) do
    aggregate_range_inc(first + 1, last, func.(first, seed), func)
  end

  defp aggregate_range_dec(first, first, seed, func) do
    func.(first, seed)
  end

  defp aggregate_range_dec(first, last, seed, func) do
    aggregate_range_dec(first - 1, last, func.(first, seed), func)
  end

  @doc """
  Finds the sum of all values in a list with numeric elements.
  
  ## Examples
  
    iex> list = [1, 2, 3]
    iex> ShittyLinqEx.sum(list)
    6
  """

  def sum([]) do
      0
  end
    
  def sum([h|t]) do
    h + sum(t)
  end
  
  defp take_list([head | _], 1), do: [head]
  defp take_list([head | tail], counter), do: [head | take_list(tail, counter - 1)]
  defp take_list([], _counter), do: []

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
