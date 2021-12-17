defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  test "part1" do
    input = "target area: x=20..30, y=-10..-5"
    result = part1(input)

    IO.inspect(result)

    assert result
  end

  test "part2" do
    input = "target area: x=20..30, y=-10..-5"
    result = part2(input)

    IO.inspect(result)

    assert result
  end
end
