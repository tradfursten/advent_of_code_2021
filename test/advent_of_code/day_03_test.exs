defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  import AdventOfCode.Day03

  test "part1" do
    input = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""
    result = part1(input)
    IO.inspect(result)
    assert result
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
