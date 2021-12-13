defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  test "part1" do
    input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""
    result = part1(input)

    IO.write("\n\n Result: ")
    IO.inspect(result)

    assert result
  end

  test "part2" do
    input = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""
    result = part2(input)

    IO.puts("Part 2:")
    IO.inspect(result)

    assert result
  end
end
