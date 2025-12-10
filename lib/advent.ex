defmodule Advent do
  def day1 do
    case File.read("data/day1.dat") do
      {:ok, body} -> process_rotation_file(body)
      {:error, reason} -> reason
    end
  end

  def process_rotation_file(body) do
    all_rotations = String.split(body)
    dial_position = 50
    zero_count = 0
    rotate(all_rotations, dial_position, zero_count)
  end

  def rotate([next_rotation | remaining_rotations], dial_position, zero_count) do
    { direction, distance } = parse_rotation(next_rotation)
    dial_position = next_position(dial_position, direction, distance)
    zero_count = if dial_position == 0 do zero_count + 1 else zero_count end
    rotate(remaining_rotations, dial_position, zero_count)
  end

  def rotate([], _dial_position, zero_count) do
    zero_count
  end

  def next_position(from, direction, distance) do
     dial_position = case direction do
      "L" -> from - distance
      "R" -> from + distance
    end

    dial_position = cond do
      dial_position < 0 -> 100 + dial_position
      dial_position > 99 -> dial_position - 100
      true -> dial_position
    end

    dial_position
  end

  def parse_rotation(input) do
    { direction, distance } = String.split_at(input, 1)
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
