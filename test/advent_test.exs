defmodule VerticalCalculatorTests do
  use ExUnit.Case
  doctest VerticalCalculator

  test "returns correct index when there's one space" do
    assert VerticalCalculator.find_split_index("+ *") == 1
  end

  test "returns correct when many operators" do
    assert VerticalCalculator.find_split_index("+   *  + *") == 3
  end
end
