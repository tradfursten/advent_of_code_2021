defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  import AdventOfCode.Day21

  @tag :skip
  test "part1" do
    input = """
Player 1 starting position: 4
Player 2 starting position: 8
"""
    result = part1({4, 8})
    |> IO.inspect

    assert result
  end

  test "part2" do
    input = {4, 8}
    result = part2(input) |> IO.inspect

    assert result
  end
end
