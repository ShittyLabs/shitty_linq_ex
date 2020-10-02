defmodule ShittyLinqExTest do
  use ExUnit.Case, async: true
  doctest ShittyLinqEx

  alias ShittyLinqEx

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
