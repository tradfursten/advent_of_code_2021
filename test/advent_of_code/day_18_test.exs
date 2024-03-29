defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  @tag :skip
  test "reduce again" do
    input = [
[[[[[9,8],1],2],3],4],
[7,[6,[5,[4,[3,2]]]]],
[[6,[5,[4,[3,2]]]],1],
[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]],
[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]]
    
    input
    |> Enum.map(&reduce/1)
    |> IO.inspect

  end

  @tag :skip
  test "part1_add" do
    input ="""
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""
    result = part1(input)
    IO.inspect(result)

    assert result == [[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]] 
  end

  @tag :skip
  test "reduce" do
    input = [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]
    result = reduce(input)

    assert result == [[3,[2,[8,0]]],[9,[5,[7,0]]]]
  end

  test "part2" do
    input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""
    result = part2(input)

    IO.inspect(result)

    assert result
  end
end
