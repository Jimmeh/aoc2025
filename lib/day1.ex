defmodule Passwords do
  defstruct [:part_one, :part_two]

  def find(filename) do
    rotations = execute_rotations(filename)

    part1 = rotations
    |> Enum.count(fn rot -> rot[:end_position] == 0 end)

    part2 = rotations
    |> Enum.reduce(0, fn rot, total -> total + rot[:zero_count] end)

    %Passwords{
      part_one: part1,
      part_two: part2
    }
  end

  def execute_rotations(filename) do
    File.stream!(filename)
    |> parse_instructions()
    |> Stream.scan(%{ :end_position => 50, :zero_count => 0 }, &next_position/2)
  end

  def next_position({direction, distance}, previous) do
    sequence = 1..distance
    |> Stream.scan(previous[:end_position], fn _tick, position ->
      position = case direction do
        :left -> position - 1
        :right -> position + 1
      end

      cond do
        position == -1 -> 99
        position == 100 -> 0
        true -> position
      end
    end)

    %{
      :end_position => Enum.at(sequence, -1),
      :zero_count => Enum.count(sequence, fn pos -> pos == 0 end)
    }
  end

  def parse_instructions(stream) do
    stream
    |> Stream.map(fn input ->
      case String.trim(input) do
        "L" <> distance -> { :left, String.to_integer(distance) }
        "R" <> distance -> { :right, String.to_integer(distance) }
      end
    end)
  end
end
