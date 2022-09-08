defmodule Mix.Tasks.D21.P2 do
  use Mix.Task

  import AdventOfCode.Day21

  @shortdoc "Day 21 Part 2"
  def run(args) do
    input = {1, 2 } #AdventOfCode.Input.get!(21, 2021) |> String.trim

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
