defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = "3,4,3,1,2" |> String.trim
    result = part1(input, 80)
    IO.inspect( result)
    assert result
  end

  test "part2" do
    input = "3,4,3,1,2" |> String.trim
    result = part2(input, 256)
    IO.inspect( result)

    assert result == 26984457539
  end
end
