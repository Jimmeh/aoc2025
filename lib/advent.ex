

defmodule Advent do
  def day1 do
    rotations = execute_rotations()

    part1 = rotations
    |> Enum.count(fn rot -> elem(rot, 0) == 0 end)

    part2 = rotations
    |> Enum.reduce(0, fn rot, total -> total + elem(rot, 1) end)

    IO.puts("part_1: #{part1}")
    IO.puts("part_2: #{part2}")
  end

  def execute_rotations() do
    File.stream!("data/day1.dat")
    |> parse_instructions()
    |> Stream.scan({ 50, 0 }, &next_position/2)
  end

  def next_position({direction, distance}, { start_position, _zeros }) do
    sequence = 1..distance
    |> Stream.scan(start_position, fn _tick, position ->
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

    { Enum.at(sequence, -1), Enum.count(sequence, fn pos -> pos == 0 end) }
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
