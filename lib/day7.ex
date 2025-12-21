defmodule LaserBeams do
  def count_beam_splits(filename) do
    generate_split_results(
      String.split(File.read!(filename))
    )
  end

  def generate_split_results(rows) do
    {splits, indices } = rows
    |> Enum.reduce({ 0, [] }, fn row, acc -> simulate_splits(row, acc) end)

    timelines = indices |> Enum.reduce(0, fn { _i, n }, acc -> acc + n end)
    { splits, timelines }
  end

  def simulate_splits(row, { total_splits, [] }) do
    initial_beam = { Enum.find_index(String.to_charlist(row), &(&1 == ?S)), 1 }
    { total_splits, [initial_beam] }
  end

  def simulate_splits(row, { total_splits, beam_indices }) do
    beam_indices
    |> Enum.reduce({total_splits, []}, fn { i, entries}, { total_splits, indices } ->
      case String.at(row, i) do
        "." -> { total_splits, increase_index(indices, i, entries) }
        "^" -> { total_splits + 1, increase_index(increase_index(indices, i-1, entries), i+1, entries) }
      end
    end)
  end

  def increase_index(indices, i, entries) do
    case Enum.find(indices, fn { index, _n} -> index == i end) do
      :nil -> indices ++ [{ i, entries }]
      _ -> indices
           |> Enum.map(fn { index, count } ->
             case i == index do
               :true -> { index, count + entries }
               :false -> { index, count }
             end
           end)
    end
  end
end
