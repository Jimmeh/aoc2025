defmodule Advent do
  def day1 do
    passwords = Passwords.find("data/day1.dat")
    IO.puts("part one: #{passwords.part_one}")
    IO.puts("part two: #{passwords.part_two}")
  end

end
