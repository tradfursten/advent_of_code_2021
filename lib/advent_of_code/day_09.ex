defmodule AdventOfCode.Day09 do
  def part1(args) do
    grid = args
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} -> {{x, y}, cell} end)
    end)
    |> Map.new()


    grid
    |> Enum.filter(fn i -> is_low_point?(i, grid) end)
    |> Enum.map(fn {{_,_}, i} -> i + 1 end)
    |> Enum.sum
  end

  defp is_low_point?({{x, y}, cell}, grid) do
    {x, y}
    |> neighbours()
    |> Enum.map(fn n -> Map.get(grid, n) end)
    |> Enum.filter(fn n -> n end)
    |> Enum.all?(fn n -> cell < n end)
  end


  defp neighbours({x, y}) do
    [
      {x, y + 1},
      {x + 1, y},
      {x, y - 1},
      {x - 1, y}
    ]
  end
  def part2(args) do
    grid = args
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {cell, x} -> {{x, y}, cell} end)
    end)
    |> Map.new()

    low_points = grid
    |> Enum.filter(fn i -> is_low_point?(i, grid) end)
    |> Enum.map(fn {p, _} -> basin(p, grid, MapSet.new([p])) |> Enum.count() end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp basin(point, grid, visited) do
    neighbours(point)
    |> Enum.map(fn n -> {n, grid[n]} end)
    |> Enum.reject(fn {n, v} -> v in [9, nil] or MapSet.member?(visited, n) end)
    |> Enum.reduce(visited, fn {n, _}, acc -> basin(n, grid, MapSet.put(acc, n)) end)
  end
end
