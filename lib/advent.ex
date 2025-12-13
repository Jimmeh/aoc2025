defmodule Advent do
  def day1 do
    File.stream!("data/day1.dat")
    |> Stream.map(&String.trim/1)
    |> Stream.scan(50, &next_position/2)
    |> Enum.count(&(&1 == 0))
  end

  def next_position(rotation, current_position) do
    { direction, distance } = parse_rotation(rotation)
    dial_position = case direction do
      "L" -> current_position - distance
      "R" -> current_position + distance
    end

    dial_position = cond do
      dial_position < 0 -> 100 + dial_position
      dial_position > 99 -> dial_position - 100
      true -> dial_position
    end

    dial_position
  end

  def parse_rotation(rotation) do
    { direction, distance } = String.split_at(rotation, 1)
    distance = get_distance(String.to_integer(distance))
    { direction, distance }
  end

  def get_distance(distance) do
    if distance > 100 do
      get_distance(distance - 100)
    else
      distance
    end
  end

end
