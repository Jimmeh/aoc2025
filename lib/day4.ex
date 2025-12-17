defmodule PaperRolls do
  def accessible_rolls(filename, keep_removing) do
    String.split(File.read!(filename))
    |> Enum.map(&String.to_charlist/1)
    |> get_removals(keep_removing)
    |> Enum.count()
  end

  def get_removals(rows, false) do find_accessible(rows) end
  def get_removals(rows, true) do get_removals(rows, []) end

  def get_removals(rows, to_apply) do
    rows = apply_removals(rows, to_apply)
    next_to_apply = find_accessible(rows)
    case Enum.count(next_to_apply) > 0 do
      :true -> to_apply ++ get_removals(rows, next_to_apply)
      :false -> to_apply
    end
  end

  def apply_removals(rows, removals) do
    Enum.reduce(removals, rows, fn {row, column}, result ->
      List.replace_at(result, row, List.replace_at(Enum.at(result, row), column, ?.))
    end)
  end

  def find_accessible(rows) do
    0..Enum.count(rows)-1
    |> Enum.flat_map(&find_accessible(rows, &1))
  end

  def find_accessible(rows, row_number) do
    this_row = Enum.at(rows, row_number)
    previous_row = cond do
      row_number == 0 -> List.duplicate(?., Enum.count(this_row))
      true -> Enum.at(rows, row_number - 1)
    end
    next_row = cond do
      row_number == Enum.count(rows) - 1 -> List.duplicate(?., Enum.count(this_row))
      true -> Enum.at(rows, row_number + 1)
    end
    process_padded_row(row_number, pad(previous_row), pad(this_row), pad(next_row))
  end

  def pad(row) do
    [?.] ++ row ++ [?.]
  end

  def process_padded_row(row_number, prev, this, next) do
    1..Enum.count(this)-2
    |> Enum.filter(fn i -> Enum.at(this, i) == ?@ end)
    |> Enum.reduce([], fn i, removals ->
      adj = [
        Enum.at(prev, i-1), Enum.at(prev, i), Enum.at(prev, i+1),
        Enum.at(this, i-1),                   Enum.at(this, i+1),
        Enum.at(next, i-1), Enum.at(next, i), Enum.at(next, i+1)
      ]
      cond do
        Enum.count(adj, fn x -> x == ?@ end) > 3 -> removals
        true -> removals ++ [{ row_number, i-1}]
      end
    end)
  end
end
