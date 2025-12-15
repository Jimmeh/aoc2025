defmodule ProductIds do
  def sum_invalid_ids(filename) do
    receive_results(0,
      String.split(File.read!(filename), ",")
      |> Stream.map(&send_for_processing/1)
      |> Enum.count()
    )
  end

  def receive_results(total, 0) do
    total
  end

  def receive_results(sum, remaining) do
    receive do
      { :invalid, number } -> receive_results(sum + number, remaining)
      { :complete } -> receive_results(sum, remaining - 1)
    end
  end

  def send_for_processing(range) do
    parent = self()
    spawn(fn -> check_range(range, parent) end)
  end

  def check_range(range, recipient) do
    to_range(range)
    |> Enum.each(fn id ->
      case check_id(Integer.to_string(id)) do
        :invalid -> send(recipient, { :invalid, id })
        :valid -> :ok
      end
    end)
    send(recipient, { :complete })
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
