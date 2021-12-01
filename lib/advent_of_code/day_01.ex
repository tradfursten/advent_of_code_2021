defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> increase?([])
    |> Enum.filter(fn i -> i == :increase end)
    |> Enum.count
    
  end

  def part2(args) do
    args
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> increase_window?([])
    |> Enum.filter(fn i -> i == :increase end)
    |> Enum.count
  end

  defp increase?([], acc), do: acc
  defp increase?([_s], acc), do: acc
  defp increase?([first | [ second | tail]], acc) when first < second, do: [:increase | increase?([second | tail], acc)]
  defp increase?([first | [ second | tail]], acc) when first > second, do: [:decrease | increase?([second | tail], acc)]


  defp increase_window?([a | [b | [c | [d | tail]]]], acc) do
    if (a + b + c) < (b + c + d) do
      [:increase | increase_window?([b | [c | [d | tail]]], acc)]
    else
      [:decrease | increase_window?([b | [c | [d | tail]]], acc)]
    end
  end
  defp increase_window?([_a | [_b | [_c | tail]]], acc), do: acc
  defp increase_window?([], acc), do: acc
end
