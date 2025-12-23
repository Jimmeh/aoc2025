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

  def day4 do
    part_one = PaperRolls.accessible_rolls("data/day4.dat", false)
    IO.puts("part one: #{part_one}")
    part_two = PaperRolls.accessible_rolls("data/day4.dat", true)
    IO.puts("part one: #{part_two}")
  end

  def day5 do
    { part_two, part_one } = Ingredients.count_fresh("data/day5.dat")
    IO.puts("part one: #{part_one}")
    IO.puts("part two: #{part_two}")
  end

  def day6 do
    part_one = VerticalCalculator.sum_of_calculations("data/day6.dat", :normal)
    IO.puts("part one: #{part_one}")
    part_two = VerticalCalculator.sum_of_calculations("data/day6.dat", :cephalopod)
    IO.puts("part two: #{part_two}")
  end

  def day7 do
    { part_one, part_two } = LaserBeams.count_beam_splits("data/day7.dat")
    IO.puts("part one: #{part_one}")
    IO.puts("part two: #{part_two}")
  end

  def day8 do
    { part_one, part_two } = JunctionBoxes.largest_circuits_product("data/day8.dat")
    IO.puts("part one: #{part_one}")
    IO.puts("part two: #{part_two}")
  end
end
