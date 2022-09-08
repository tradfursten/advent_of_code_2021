defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  @simple """
on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10
"""
  test "part1" do
    input = @simple
    result = part1(input) |> IO.inspect

    assert result
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
