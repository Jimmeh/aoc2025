defmodule Advent do
  def day1 do
    passwords = Passwords.find("data/day1.dat")
    IO.puts("part one: #{passwords.part_one}")
    IO.puts("part two: #{passwords.part_two}")
  end

  def day2 do
    part_one = ProductIds.sum_invalid_ids("data/day2.dat", :part_one)
    IO.puts("part one: #{part_one}")
    part_two = ProductIds.sum_invalid_ids("data/day2.dat", :part_two)
    IO.puts("part two: #{part_two}")
  end

  def day3 do
    part_one = BatteryBank.total_joltage("data/day3.dat", 2)
    IO.puts("part one: #{part_one}")
    part_two = BatteryBank.total_joltage("data/day3.dat", 12)
    IO.puts("part one: #{part_two}")
  end
end
