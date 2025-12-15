defmodule Advent do
  def day1 do
    passwords = Passwords.find("data/day1.dat")
    IO.puts("part one: #{passwords.part_one}")
    IO.puts("part two: #{passwords.part_two}")
  end

  def day2 do
    invalid_count = ProductIds.sum_invalid_ids("data/day2.dat")
    IO.puts("part one: #{invalid_count}")
  end
end
