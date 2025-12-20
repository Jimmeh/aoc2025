defmodule VerticalCalculator do
  def sum_of_calculations(filename, number_system \\ :normal) do
    rows = split_on_whitespace(
      String.split(File.read!(filename), "\n")
    )

    total_sums = length(Enum.at(rows, 0))

    0..total_sums-1
    |> Enum.map(&calculate_sum(&1, rows, number_system))
    |> Enum.sum()
  end

  def calculate_sum(column_index, rows, number_system) do
    operators = List.last(rows) |> Enum.map(&String.trim/1)
    numbers = Enum.drop(rows, -1)

    numbers = 0..length(numbers)-1
    |> Enum.map(fn row_index -> Enum.at(Enum.at(numbers, row_index), column_index) end)

    operator = Enum.at(operators, column_index)
    case number_system do
      :normal -> calculate(operator, build_numbers(numbers, []))
      :cephalopod -> calculate(operator, build_cephalopod_numbers(numbers))
    end

  end

  def calculate("+", numbers) do Enum.sum(numbers) end
  def calculate("*", numbers) do Enum.product(numbers) end

  def build_cephalopod_numbers(numbers) do
    max_digits = numbers |> Enum.map(&String.length/1) |> Enum.max()
    (max_digits-1)..0
    |> Enum.map(&vertical_number(&1, numbers))
  end

  def vertical_number(index, numbers) do
    digits = numbers
    |> Enum.map(fn n ->
      case String.at(n, index) do
        :nil -> :nil
        " " -> :nil
        num -> String.to_integer(num)
      end
    end)
    |> Enum.filter(&(&1 != :nil))

    0..length(digits)-1
    |> Enum.map(fn d ->
      Enum.at(digits, d) * 10 ** (length(digits)-1-d)
    end)
    |> Enum.sum()
  end

  def build_numbers([], converted) do converted end
  def build_numbers([input | inputs], converted) do
    build_numbers(inputs, converted ++ [String.to_integer(String.trim(input))])
  end

  def split_on_whitespace(rows) do
    split_on_whitespace(rows, List.duplicate([], length(rows)))
  end

  def split_on_whitespace(rows, mapped) do
    { new_rows, new_mapped } = map_next(rows, mapped)
    case String.trim(List.last(rows)) do
      "" -> mapped
      _ -> split_on_whitespace(new_rows, new_mapped)
    end

  end

  def map_next(rows, mapped) do
    map(String.split(List.last(rows), [" *", " +"], parts: 2), rows, mapped)
  end

  def map([_last], rows, mapped) do
    new_mapped = 0..Enum.count(mapped)-1
    |> Enum.map(fn i -> Enum.at(mapped, i) ++ [Enum.at(rows, i)] end)
    { List.duplicate("", Enum.count(new_mapped)), new_mapped}
  end

  def map([first, _rest], rows, mapped) do
    split_index = String.length(first)
    new_mapped = 0..Enum.count(mapped)-1
    |> Enum.map(fn i -> Enum.at(mapped, i) ++ [String.slice(Enum.at(rows, i), 0..split_index-1)] end)
    new_rows = 0..Enum.count(mapped)-1
    |> Enum.map(fn i -> String.slice(Enum.at(rows, i), split_index+1..-1//1) end)
    { new_rows, new_mapped }
  end
end
