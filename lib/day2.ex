defmodule ProductIds do
  def sum_invalid_ids(filename) do
    String.split(File.read!(filename), ",")
    |> Stream.map(&invalid_sum/1)
    |> Enum.sum()
  end

  def invalid_sum(range) do
    to_range(range)
    |> Enum.reduce(0, fn id, invalid_sum ->
      case check_id(Integer.to_string(id)) do
        :valid -> invalid_sum
        :invalid -> invalid_sum + id
      end
    end)
  end

  def check_id(id) do
    cond do
      String.length(id) <= 1 -> :valid
      true -> check_for_repetitions(id)
    end
  end

  def check_for_repetitions(id) do
    length = String.length(id)

    is_invalid = 1..div(length, 2)
    |> Stream.filter(&( rem(length, &1) == 0 ))
    |> Enum.any?(fn size ->
      (id
        |> String.codepoints()
        |> Stream.chunk_every(size)
        |> Stream.map(&Enum.join/1)
        |> Stream.uniq()
        |> Enum.count()
      ) == 1
    end)

    case is_invalid do
      :true -> :invalid
      :false -> :valid
    end
  end

  defp to_range(range) do
    [bottom, top] = String.split(range, "-")
    String.to_integer(String.trim(bottom))..String.to_integer(String.trim(top))
  end
end
