defmodule VerticalCalculator do
  def sum_of_calculations(filename) do
    rows = File.stream!(filename)
    |> Enum.map(&split_on_whitespace/1)

    total_sums = length(Enum.at(rows, 0))

    0..total_sums-1
    |> Enum.map(&calculate(&1, rows))
    |> Enum.sum()
  end

  def calculate(column_index, rows) do
    inputs = 0..length(rows)-1
    |> Enum.map(fn row_index -> Enum.at(Enum.at(rows, row_index), column_index) end)

    build_calculation(inputs, [])
  end

  def build_calculation(["+"], converted) do Enum.sum(converted) end
  def build_calculation(["*"], converted) do Enum.reduce(converted, 1, fn i, acc -> acc * i end) end
  def build_calculation([input | inputs], converted) do
    build_calculation(inputs, converted ++ [String.to_integer(input)])
  end

  def split_on_whitespace(input) do
    String.split(String.trim(input))
  end
end
