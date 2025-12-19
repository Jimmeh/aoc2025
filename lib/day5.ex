defmodule Ingredients do
  def count_fresh(filename) do
    { ranges, fresh_in_stock } = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({ [], 0 }, &parse_input/2)

    fresh_items = combine_ranges(ranges)
    |> Enum.reduce(0, fn { bottom, top }, acc -> acc + top - bottom + 1 end)

    { fresh_items, fresh_in_stock }
  end

  def combine_ranges(ranges) do
    result = ranges
    |> Enum.map(fn range ->
      ranges
      |> Enum.reduce(range, fn range, to_check -> combine_if_overlapping(to_check, range) end)
    end)
    |> Enum.uniq()

    case result == ranges do
      :true -> result
      :false -> combine_ranges(result)
    end
  end

  def combine_if_overlapping({ b1, t1 }, { b2, t2 }) do
    { comb_b, comb_t } = combine_range({b1, t1}, { b2, t2 })
    case Range.size(Range.new(b1, t1)) + Range.size(Range.new(b2, t2)) > Range.size(Range.new(comb_b, comb_t)) do
      :true -> { comb_b, comb_t }
      :false -> { b1, t1 }
    end
  end

  def combine_range({ b1, t1 }, { b2, t2 }) do
     { min(b1, b2), max(t1, t2) }
  end

  def parse_input(line, { ranges, fresh_count }) do
    case String.split(line, "-") do
      [""] -> { ranges, fresh_count }
      [ bottom, top ] -> { ranges ++ [to_interval(bottom, top)], fresh_count }
      [ingredient] -> case is_fresh(ranges, ingredient) do
        :true -> { ranges, fresh_count + 1}
        :false -> { ranges, fresh_count }
      end
    end
  end

  def to_interval(bottom, top) do
    { String.to_integer(bottom), String.to_integer(top) }
  end

  def is_fresh(ranges, ingredient) do
    as_num = String.to_integer(ingredient)
    Enum.any?(ranges, fn { bottom, top } ->
      bottom <= as_num and as_num <= top
    end)
  end
end
