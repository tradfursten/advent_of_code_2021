defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&expand/1)
    |> Enum.reduce(%{}, &create_grid/2)
    |> Map.values()
    |> Enum.filter(fn i -> i > 1 end)
    |> Enum.count
  end

  defp parse(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(fn l -> 
      l 
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      end)
  end

  defp expand([[x, y], [x, z]]) do
    for i <- y..z do
      {x, i}
    end
  end
  defp expand([[x, y], [z, y]]) do
    for i <- x..z do
      {i, y}
    end
  end
  defp expand(_), do: []

  defp create_grid([], acc), do: acc
  defp create_grid([{x, y} | tail], acc) do
    create_grid(tail, Map.update(acc, {x, y}, 1, fn i -> i + 1 end))
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse/1)
    |> Enum.map(&expand_dig/1)
    |> Enum.reduce(%{}, &create_grid/2)
    |> Map.values()
    |> Enum.filter(fn i -> i > 1 end)
    |> Enum.count
  end

  defp expand_dig([[x, y], [x, z]]) do
    for i <- y..z do
      {x, i}
    end
  end

  defp expand_dig([[x, y], [z, y]]) do
    for i <- x..z do
      {i, y}
    end
  end

  defp expand_dig([[x, y], [z, w]]) do
    Enum.zip([x..z, y..w])
  end
end
