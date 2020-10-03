defmodule ShittyLinqExTest do
  use ExUnit.Case, async: true
  doctest ShittyLinqEx

  describe "reverse/1" do
    test "empty list" do
      assert ShittyLinqEx.reverse([]) == []
    end

    test "normal list" do
      assert ShittyLinqEx.reverse([1, 3, 5, 7]) == [7, 5, 3, 1]
    end

    test "big list" do
      assert ShittyLinqEx.reverse(Enum.to_list(1..1_000_000)) == Enum.to_list(1_000_000..1)
    end
  end

  describe "first/1" do
    test "empty list" do
      assert ShittyLinqEx.first([]) == nil
    end

    test "normal list with same type" do
      assert ShittyLinqEx.first([1, 2, 3]) == 1
    end

    test "normal list with jumbled type" do
      assert ShittyLinqEx.first(["A", 1, :A]) == "A"
    end

    test "big list" do
      assert ShittyLinqEx.first(Enum.to_list(1..1_000_000)) == 1
    end

    test "nil value" do
      assert ShittyLinqEx.first(nil) == nil
    end
  end
end
