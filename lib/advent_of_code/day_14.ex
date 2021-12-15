defmodule AdventOfCode.Day14 do
  def part1(args) do
    split = args
    |> String.split("\n", trim: true)

    template = Enum.at(split,0) |> String.graphemes

    mapping = split
    |> Enum.slice(1, 200)
    |> Enum.map(fn l ->
      r = l
      |> String.split(" -> ")

      i = r |> Enum.at(0) |> String.graphemes |> Enum.to_list |> List.to_tuple
      {i, Enum.at(r, 1)}
    end)
    |> Enum.reduce(%{}, fn {i, o}, acc -> Map.put(acc, i, o) end)

    do_react(template, mapping, 10)
  end

  defp do_react(template, _, 0) do
    freq = template
    |> Enum.frequencies
    |> Map.to_list

    max = freq |> Enum.max_by(fn {_, x} -> x end)
    min = freq |> Enum.min_by(fn {_, x} -> x end)

    elem(max, 1) - elem(min, 1)
  end
  defp do_react(template, mapping, i) do
    IO.puts("Iteration #{i}")
    IO.puts(template |> Enum.join)
    do_react(react(template, mapping), mapping, i - 1)
  end


  defp react([], _), do: []
  defp react([x | []], _), do: [x]
  defp react([x | [y | _] = tail], mapping) do
    case Map.get(mapping, {x, y}, "") do
      "" -> [x | react(tail, mapping)]
      r -> [x | [r | react(tail, mapping)]]
    end
  end
    

  def part2(args) do
    split = args
    |> String.split("\n", trim: true)

    template = Enum.at(split,0) 
    |> String.graphemes
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x |> List.to_tuple, 1, fn i -> i + 1 end) end)

    IO.inspect(template)

    mapping = split
    |> Enum.slice(1, 200)
    |> Enum.map(fn l ->
      r = l
      |> String.split(" -> ")

      i = r |> Enum.at(0) |> String.graphemes |> Enum.to_list |> List.to_tuple
      {i, Enum.at(r, 1)}
    end)
    |> Enum.reduce(%{}, fn {i, o}, acc -> Map.put(acc, i, o) end)

    do_react2(template, mapping, 40)
  end

  defp do_react2(template, _, 0) do
    freq = template
    |> Map.to_list
    |> Enum.reduce(%{}, fn {{a, b}, c}, acc -> 
      IO.inspect(acc)
      acc
      |> Map.update(a, c, fn i -> i + c end)
      |> Map.update(b, c, fn i -> i + c end)
    end)
    |> Map.to_list

    IO.inspect(freq)

    max = freq |> Enum.max_by(fn {_, x} -> x end)
    min = freq |> Enum.min_by(fn {_, x} -> x end)

    (elem(max, 1) - elem(min, 1) + 1) / 2
  end
  defp do_react2(template, mapping, i) do
    IO.puts("Iteration #{i}")
    IO.inspect(template)
    do_react2(react2(template |> Map.to_list, mapping), mapping, i - 1)
  end

  defp react2(l, mapping) do
    # IO.inspect(l)
    l
    |> Enum.reduce(%{}, fn {{x, y}, c}, acc ->
      case Map.get(mapping, {x, y}, "") do
        "" -> Map.update(acc, {x, y}, c, fn i -> i + c end)
        r -> 
          # IO.puts("Found a match #{r}")
          acc
          |> Map.update({x, r}, c, fn i -> i + c end)
          |> Map.update({r, y}, c, fn i -> i + c end)
      end
    end)

  end


end
