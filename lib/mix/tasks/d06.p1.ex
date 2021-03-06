defmodule Mix.Tasks.D06.P1 do
  use Mix.Task

  import AdventOfCode.Day06

  @shortdoc "Day 06 Part 1"
  def run(args) do
    input = AdventOfCode.Input.get!(6, 2021) |> String.trim

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(10) end}),
      else:
        input
        |> part1(80)
        |> IO.inspect(label: "Part 1 Results")
  end
end
