defmodule ShittyLinqExTest do
  use ExUnit.Case, async: true
  doctest ShittyLinqEx

  alias ShittyLinqEx

  test "all: empty list should return true" do
    assert ShittyLinqEx.all([], fn _ -> true end) == true
  end

  test "all: should return false" do
    assert ShittyLinqEx.all(
      ["Barley", "Boots", "Whiskers"],
      fn pet -> String.first(pet) == "B" end) == false
  end

  test "all: should return true" do
    assert ShittyLinqEx.all(
      [1, 3, 5, 7, 9],
      fn number -> rem(number,2) == 1 end) == true
  end

  test "reverse of empty list" do
    assert ShittyLinqEx.reverse([]) == []
  end

  test "reverse of normal list" do
    assert ShittyLinqEx.reverse([1, 3, 5, 7]) == [7, 5, 3, 1]
  end

  test "reverse of big list" do
    assert ShittyLinqEx.reverse(Enum.to_list(1..1_000_000)) == Enum.to_list(1_000_000..1)
  end
end
