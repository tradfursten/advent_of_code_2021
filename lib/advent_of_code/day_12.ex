defmodule AdventOfCode.Day12 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> l |> String.split("-") |> List.to_tuple end)
    |> Enum.reduce(%{}, fn {from, to}, graph -> 
      graph
      |> Map.update(from, [to], fn neighbours -> [to | neighbours] end)
      |> Map.update(to, [from], fn neighbours -> [from | neighbours] end)
    end)
    |> count("start", ["start"], false, 0)
  end

  defp count(_, "end", _, _, count), do: count + 1
  defp count(graph, node, visited, twice?, count) do
    #IO.puts("count from #{node}, current count #{count}, visited [#{visited |> Enum.join(", ")}]")
    traverse(Map.get(graph, node, []), visited, graph, twice?, count)
  end


  defp traverse([], _, _, _, count), do: count
  defp traverse([neighbour | neighbours], visited, graph, twice?, count) do
    if String.upcase(neighbour) == neighbour or neighbour not in visited do
      traverse(neighbours, visited, graph, twice?, count + count(graph, neighbour, [neighbour | visited], twice?, 0))
    else
      if neighbour not in ["start", "end"] and twice? do
        traverse(neighbours, visited, graph, twice?, count + count(graph, neighbour, [neighbour | visited], false, 0))
      else
        traverse(neighbours, visited, graph, twice?, count)
      end
    end

  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> l |> String.split("-") |> List.to_tuple end)
    |> Enum.reduce(%{}, fn {from, to}, graph -> 
      graph
      |> Map.update(from, [to], fn neighbours -> [to | neighbours] end)
      |> Map.update(to, [from], fn neighbours -> [from | neighbours] end)
    end)
    |> count("start", ["start"], true, 0)
  end
end
