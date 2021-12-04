defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> String.graphemes
    |> Enum.frequencies
    |> Map.to_list
    |> Enum.sort(fn {a, c1}, {b, c2} ->
          case c1 do
            ^c2 -> a < b
          _  -> c1 > c2
        end
      end)
  end

  def part2(args) do
  end
end
