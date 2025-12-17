defmodule BatteryBank do
  def total_joltage(filename, batteries_required) do
    File.stream!(filename)
    |> Stream.map(&to_integer_list/1)
    |> Stream.map(&calculate_joltage(&1, batteries_required-1))
    |> Enum.sum()
  end

  def to_integer_list(string) do
    String.graphemes(String.trim(string))
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_joltage(batteries, batteries_required) do
    find_max(batteries, batteries_required, [])
    |> Enum.sum()
  end

  def find_max(batteries, remaining, selected) do
    v = Enum.drop(batteries, -remaining)
    |> Enum.max()

    selected = selected ++ [v * 10 ** remaining]
    if remaining == 0 do
      selected
    else
      i = Enum.find_index(batteries, fn x -> x == v end)
      { _discard, remaining_batteries } = Enum.split(batteries, i+1)
      find_max(remaining_batteries, remaining - 1, selected)
    end
  end
end
