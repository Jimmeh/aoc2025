defmodule LaserBeamsTests do
  use ExUnit.Case
  doctest LaserBeams

  test "generates timelines with 2 rows" do
    rows = [
      "..S..",
      ".....",
      "..^..",
      ".....",
      ".^.^.",
      "....."
    ]
    { _splits, timelines } = LaserBeams.generate_split_results(rows)
    assert timelines == 4
  end

  test "generates timelines with 3 rows" do
    rows = [
      "...S...",
      ".......",
      "...^...",
      ".......",
      "..^.^..",
      ".......",
      ".^...^.",
      "......."
    ]
    { _splits, timelines } = LaserBeams.generate_split_results(rows)
    assert timelines == 6
  end

  test "generates timelines with 4 rows" do
    rows = [
      "....S....",
      ".........",
      "....^....",
      ".........",
      "...^.^...",
      ".........",
      "..^...^..",
      ".........",
      ".^.^.^.^.",
      "........."
    ]
    { _splits, timelines } = LaserBeams.generate_split_results(rows)
    assert timelines == 10
  end
end
