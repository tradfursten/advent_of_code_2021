defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  @tag timeout: :infinity
  test "part1" do
    input = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""
    result = part1(input)
    IO.inspect(result)

    assert result
  end

  test "part2" do
    input = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""
    result = part2(input)
    IO.inspect(result)

    assert result
  end
end
