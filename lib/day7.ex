defmodule LaserBeams do
  def count_beam_splits(filename) do
    {splits, _indices } = String.split(File.read!(filename))
    |> Enum.reduce({ 0, [] }, fn row, acc -> simulate_splits(row, acc) end)
    splits
  end


  def simulate_splits(row, { total_splits, [] }) do
    { total_splits, [Enum.find_index(String.to_charlist(row), &(&1 == ?S))] }
  end

  def simulate_splits(row, { total_splits, beam_indices }) do
    { total_splits, indices } = beam_indices
    |> Enum.reduce({total_splits, []}, fn i, { total_splits, indices } ->
      case String.at(row, i) do
        "S" -> { total_splits, indices ++ [i] }
        "." -> { total_splits, indices ++ [i] }
        "^" -> { total_splits + 1, indices ++ [i-1, i+1] }
      end
    end)
    { total_splits, Enum.uniq(indices) }
  end
end
