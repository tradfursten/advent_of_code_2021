defmodule AdventOfCode.Day08 do
  def part1(args) do
   args
   |> String.trim()
   |> String.split("\n")
   |> Enum.map(fn l ->
      b = l
      |> String.split("|")
      Enum.at(b, 1)
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&get_number/1)
      |> Enum.filter(fn n -> n != nil end)
      |> Enum.count()

   end)
   |> Enum.sum

  end


  defp get_number(s) do
    case String.length(s) do
      2 -> 1
      3 -> 7
      4 -> 4
      7 -> 8
      _ -> nil
    end
  end

  

  def part2(args) do
   args
   |> String.trim()
   |> String.split("\n")
   |> Enum.map(fn l ->
      b = l
      |> String.split("|")
      numbers = Enum.at(b, 0)
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(fn s -> s |> String.codepoints |> Enum.sort end)
      |> guess_the_numbers(%{})
      |> Map.to_list()
      |> Enum.map(fn {n, c} -> {Enum.join(c, ""), n} end)
      |> Enum.into(%{})

      
      j = Enum.at(b, 1)
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(fn s -> 
        p = s |> String.codepoints() |> Enum.sort |> Enum.join("") 
        Map.get(numbers, p)
      end)
      |> Enum.join
      |> String.to_integer

      if map_size(numbers) != 10 do
        IO.inspect(l)
        IO.inspect(numbers)
        IO.inspect(j)
      end
      j
   end)
   |> Enum.sum
  end

  defp guess_the_numbers([], numbers), do: numbers
  defp guess_the_numbers([head | tail], numbers) do
    case Enum.count(head) do
      2 -> guess_the_numbers(tail, Map.put(numbers, "1", head))
      3 -> guess_the_numbers(tail, Map.put(numbers, "7", head))
      4 -> guess_the_numbers(tail, Map.put(numbers, "4", head))
      7 -> guess_the_numbers(tail, Map.put(numbers, "8", head))
      6 ->
        cond do
          contains_segments?(head, "4", numbers) ->
            guess_the_numbers(tail, Map.put(numbers, "9", head))
          (contains_segments?(head, "5", numbers) and not contains_segments?(head, "7", numbers)) or
            (Map.has_key?(numbers, "9") and Map.has_key?(numbers, "0"))->
            guess_the_numbers(tail, Map.put(numbers, "6", head))
          Map.has_key?(numbers, "9") and (Map.has_key?(numbers, "6") or contains_segments?(head, "7", numbers)) ->
            guess_the_numbers(tail, Map.put(numbers, "0", head))
          true -> 
            #IO.puts("6 segments, not posible")
            guess_the_numbers(tail ++ [head], numbers)
        end
      5 -> 
        cond do
          contains_segments?(head, "7", numbers) ->
            guess_the_numbers(tail, Map.put(numbers, "3", head))
          Map.has_key?(numbers, "3") and Map.has_key?(numbers, "9") ->
            nine = Map.get(numbers, "9", [])
            left = Enum.reject(nine, fn n -> Enum.member?(head, n) end)
            case Enum.count(left) do
              1 -> guess_the_numbers(tail, Map.put(numbers, "5", head))
              2 -> guess_the_numbers(tail, Map.put(numbers, "2", head))
              _ -> IO.puts("what!")
            end
          true ->
            guess_the_numbers(tail ++ [head], numbers)
        end
      _ -> 
        #IO.puts("no match")
        guess_the_numbers(tail, numbers)
    end
  end

  defp contains_segments?(segments, check, numbers) do
    Map.get(numbers, check, ["ö"]) |> Enum.all?(fn n -> Enum.member?(segments, n) end)
  end
  defp all_is_contained_in?(segments, check, numbers) do
    check = Map.get(numbers, check, ["ö"])
    segments |> Enum.all?(fn n -> Enum.member?(check, n) end)
  end
end
