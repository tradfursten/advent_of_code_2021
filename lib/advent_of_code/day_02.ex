defmodule AdventOfCode.Day02 do
  def part1(args) do
    list =
      args
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn s ->
        split = String.split(s)
        {Enum.at(split, 0), split |> Enum.at(1) |> String.to_integer()}
      end)

    {h, v} = navigate(list, {0, 0})
    IO.puts("Part 1: #{h * v}")
    h * v
  end

  def part2(args) do
    list =
      args
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn s ->
        split = String.split(s)
        {Enum.at(split, 0), split |> Enum.at(1) |> String.to_integer()}
      end)

    {h, v, a} = navigate_aim(list, {0, 0, 0})
    IO.inspect({h, v, a})
    IO.puts("Part 2: #{h * v}")
    h * v
  end

  defp navigate([{"forward", i} | tail], {h, v}), do: navigate(tail, {h + i, v})
  defp navigate([{"up", i} | tail], {h, v}), do: navigate(tail, {h, v - i})
  defp navigate([{"down", i} | tail], {h, v}), do: navigate(tail, {h, v + i})
  defp navigate([], acc), do: acc

  defp navigate_aim([{"forward", i} | tail], {h, v, a}),
    do: navigate_aim(tail, {h + i, v + a * i, a})

  defp navigate_aim([{"up", i} | tail], {h, v, a}), do: navigate_aim(tail, {h, v, a - i})
  defp navigate_aim([{"down", i} | tail], {h, v, a}), do: navigate_aim(tail, {h, v, a + i})
  defp navigate_aim([], acc), do: acc
end

