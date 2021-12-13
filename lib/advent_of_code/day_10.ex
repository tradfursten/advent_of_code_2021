defmodule AdventOfCode.Day10 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l -> corrupted(l, []) end)
    |> Enum.reject(fn
      {:corrupted, _} -> false
      {:incomplete} -> true
     end)
    |> Enum.map(fn {_, n} -> score(n) end)
    |> Enum.sum
  end

  defp corrupted([], _), do: {:incomplete}
  defp corrupted([c | tail], [] = rest) do
    IO.write("\n")
    IO.write(c)
    case c do 
      "(" -> corrupted(tail, [")" | rest])  
      "<" -> corrupted(tail, [">" | rest])  
      "[" -> corrupted(tail, ["]" | rest])  
      "{" -> corrupted(tail, ["}" | rest])  
    end
  end
  defp corrupted([c | tail], [closing | rest_tail] = rest) do
    IO.write(c)
    #IO.inspect(c == closing)
    case c do 
      "(" -> corrupted(tail, [")" | rest])  
      "<" -> corrupted(tail, [">" | rest])  
      "[" -> corrupted(tail, ["]" | rest])  
      "{" -> corrupted(tail, ["}" | rest])  
      ^closing -> corrupted(tail, rest_tail)
      broken_char -> 
        #IO.puts("Got #{c} expected closing #{closing}")
        {:corrupted, broken_char}
    end

  end

  defp score(")"), do: 3 
  defp score("]"), do: 57 
  defp score("}"), do: 1197 
  defp score(">"), do: 25137 

  def part2(args) do
    lines = args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l -> incomplete(l, []) end)
    |> Enum.reject(fn
      {:corrupted, _} -> true
      {:incomplete, _} -> false
     end)
    |> Enum.map(fn {_, n} -> Enum.map(n, &score2/1) |> Enum.reduce(0, fn x, acc -> acc * 5 + x end) end)
    |> Enum.sort


    Enum.at(lines, round(Enum.count(lines)/2))
  end

  defp incomplete([], stack), do: {:incomplete, stack}
  defp incomplete([c | tail], [] = rest) do
    IO.write("\n")
    IO.write(c)
    case c do 
      "(" -> incomplete(tail, [")" | rest])  
      "<" -> incomplete(tail, [">" | rest])  
      "[" -> incomplete(tail, ["]" | rest])  
      "{" -> incomplete(tail, ["}" | rest])  
    end
  end
  defp incomplete([c | tail], [closing | rest_tail] = rest) do
    IO.write(c)
    #IO.inspect(c == closing)
    case c do 
      "(" -> incomplete(tail, [")" | rest])  
      "<" -> incomplete(tail, [">" | rest])  
      "[" -> incomplete(tail, ["]" | rest])  
      "{" -> incomplete(tail, ["}" | rest])  
      ^closing -> incomplete(tail, rest_tail)
      broken_char -> 
        #IO.puts("Got #{c} expected closing #{closing}")
        {:corrupted, broken_char}
    end
  end

  defp score2(")"), do: 1
  defp score2("]"), do: 2
  defp score2("}"), do: 3
  defp score2(">"), do: 4
end
