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
  - `predicate`: A function to test each element for a condition.

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
  def all(list, predicate) when is_list(list) and is_function(predicate, 1),
    do: do_all(list, predicate)

  defp do_all([], _predicate), do: true
  defp do_all([head | tail], predicate), do: predicate.(head) && do_all(tail, predicate)

  @doc """
  Determines whether a sequence contains any elements.

  ## Parameters
  - `list`: the `list` to check for emptiness.

  ## Returns
  `true` if the source sequence contains any elements; otherwise, `false`.

  ## Examples

    iex> import ShittyLinqEx, only: [any: 1]
    iex> any([])
    false

    iex> import ShittyLinqEx, only: [any: 1]
    iex> any([1, 3, 5, 7, 9])
    true
  """
  @spec any(list) :: bool
  def any(list), do: any(list, fn _ -> true end)

  @doc """
  Determines whether any element of a sequence satisfies a condition.

  ## Parameters
  - `list`: A list that contains the elements to apply the predicate to.
  - `predicate`: A function to test each element for a condition.

  ## Returns
  `true` if the source sequence is not empty and at least one of its elements passes the test in the specified predicate; otherwise, `false`.

  ## Examples

    iex> import ShittyLinqEx, only: [any: 2]
    iex> any(
    ...>  [ %{ name: "Barley", age: 8, vaccinated: true },
    ...>    %{ name: "Boots", age: 4, vaccinated: false },
    ...>    %{ name: "Whiskers", age: 1, vaccinated: false } ],
    ...>  fn pet -> pet.age > 1 && pet.vaccinated == false end)
    true

    iex> import ShittyLinqEx, only: [any: 2]
    iex> any(
    ...>  [1, 3, 5, 7, 9],
    ...>  fn number -> number == 0 end)
    false
  """
  @spec any(list, fun) :: bool
  def any(list, predicate) when is_list(list) and is_function(predicate, 1),
    do: do_any(list, predicate)

  defp do_any([], _predicate), do: false
  defp do_any([head | tail], predicate), do: predicate.(head) || do_any(tail, predicate)

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
  Places a new element at the end of an existing list
  
  ## Examples
  
    iex> a = [1, 2, 3]
    iex> b = ShittyLinqEx.append(a, 4)
    [1, 2, 3, 4]
    iex> c = ShittyLinqEx.append(b, 327)
    [1, 2, 3, 4, 327]
  """

  def append(list, new) do
    list ++ [new]
  end

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
  Returns a new enumerable collection that contains the last count elements from source.

  ## Parameters

  - `source`: A sequence of values to take.
  - `count`: The number of elements to take from the end of the collection.

  ## Returns

  A new enumerable collection that contains the last count elements from source.

  ## Examples

    iex> import ShittyLinqEx, only: [take_last: 2]
    iex> take_last(["A", "B", "C"], 2)
    ["B", "C"]

    iex> import ShittyLinqEx, only: [take_last: 2]
    iex> take_last([42, "orange", :atom], 7)
    [42, "orange", :atom]

    iex> import ShittyLinqEx, only: [take_last: 2]
    iex> take_last([1, 2, 3], 0)
    []

    iex> import ShittyLinqEx, only: [take_last: 2]
    iex> take_last(nil, 5)
    nil

  """

  def take_last(nil, _count), do: nil

  def take_last(source, count) do
    source
    |> reverse()
    |> take(count)
    |> reverse()
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

  @doc """
  Return the value repeated n times inside a list,

  ## Parameters

  - `value`: a value to repeat.
  - `count`: the number of times that the `value` can be repeated.

  ## Returns

  Returns a list with the value repeated `count` times, if
  value is equal 0 or less it will raise an error

  ## Examples

    iex> import ShittyLinqEx, only: [repeat: 2]
    iex> repeat("Hello there", 10)

    ["Hello there", "Hello there", "Hello there", "Hello there", "Hello there",
     "Hello there", "Hello there", "Hello there", "Hello there", "Hello there"]

    iex> import ShittyLinqEx, only: [repeat: 2]
    iex> repeat(%{"map" => "Example", "key" => "value"}, 5)
    \n
   [
   %{"key" => "value", "map" => "Example"},
   %{"key" => "value", "map" => "Example"},
   %{"key" => "value", "map" => "Example"},
   %{"key" => "value", "map" => "Example"},
   %{"key" => "value", "map" => "Example"}
   ]

  """

  def repeat(_value, count) when count <= 0 do
    raise "Count must be 1 or more"
  end

  def repeat(_value, count) when not is_number(count) do
    raise "Count must be a number"
  end

  def repeat(value, 1), do: value

  def repeat(value, count) do
    for _ <- 1..count do
      value
    end
  end

  @doc """
  Return the value when no count is passed

  ## Parameters

  - `value`: a value to repeat.

  ## Returns

  The value itself besauce no count was passed

  ## Examples
  iex> import ShittyLinqEx, only: [repeat: 1]
  iex> repeat("hi")
  "hi"
  """
  def repeat(value), do: value

  @doc ~S"""
  Projects each element of a sequence into a new form.

  ## Parameters
  - `list`: A sequence of values to invoke a transform function on.
  - `selector`: A transform function to apply to each element.

  ## Returns
  A list whose elements are the result of invoking the transform function on each element of `list`.

  ## Examples

    iex> import ShittyLinqEx, only: [select: 2]
    iex> select(
    ...>  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    ...>  fn x -> x * x end)
    [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

    iex> import ShittyLinqEx, only: [select: 2]
    iex> select(
    ...>  ["apple", "banana", "mango", "orange", "passionfruit", "grape"],
    ...>  fn fruit, index -> "#{index} #{fruit}" end)
    ["0 apple", "1 banana", "2 mango", "3 orange", "4 passionfruit", "5 grape"]
  """
  def select(list, selector) when is_list(list) and is_function(selector, 1),
    do: select(list, fn element, _index -> selector.(element) end)

  def select(list, selector) when is_list(list) and is_function(selector, 2),
    do: do_select(list, selector, 0)

  defp do_select([head], selector, index), do: [selector.(head, index)]

  defp do_select([head | tail], selector, index),
    do: [selector.(head, index) | do_select(tail, selector, index + 1)]

  @doc """
  Computes the sum of a sequence of numeric values.

  ## Parameters
  - `list`: A sequence of numeric values to calculate the sum of.

  ## Returns
  The sum of the values in the sequence.

  ## Examples

    iex> import ShittyLinqEx, only: [sum: 1]
    iex> sum([])
    0

    iex> import ShittyLinqEx, only: [sum: 1]
    iex> sum([1, 1, 2, 3, 5])
    12
  """
  def sum(list) when is_list(list), do: sum(list, fn value -> value end)

  @doc """
  Computes the sum of the sequence of numeric values that are obtained by
  invoking a transform function on each element of the input sequence.

  ## Parameters
  - `list`: A sequence of values that are used to calculate a sum.
  - `selector`: A transform function to apply to each element.

  ## Returns
  The sum of the projected values.

  ## Examples

    iex> import ShittyLinqEx, only: [sum: 2]
    iex> sum(
    ...>  [ %{ company: "Coho Vineyard", weight: 25.2 },
    ...>    %{ company: "Lucerne Publishing", weight: 18.7 },
    ...>    %{ company: "Wingtip Toys", weight: 6.0 },
    ...>    %{ company: "Adventure Works", weight: 33.8 } ],
    ...> fn package -> package.weight end)
    83.7
  """
  def sum(list, selector) when is_list(list) and is_function(selector, 1),
    do: do_sum(list, selector)

  defp do_sum([], _selector), do: 0
  defp do_sum([head | tail], selector), do: selector.(head) + do_sum(tail, selector)
end
