defmodule AdventOfCode.Day11 do
  def part1(args) do
    octopus = args
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {l, y} -> 
      l 
      |> String.graphemes 
      |> Enum.map(&String.to_integer/1) 
      |> Enum.with_index 
      |> Enum.map(fn {c, x} -> {{x, y}, c} end)
    end)
    #|> Enum.reduce(%{}, fn({k, v}, acc)-> Map.put(acc, k, v) end)

    #IO.puts("Before any iterations")
    #print(octopus)

    res = flash(octopus, 0, 0)
    res
  end

  defp print(octopus) do
    octopus
    |> Enum.sort(fn {{x_a, y_a}, _}, {{x_b, y_b}, _} ->
      cond do
        y_a < y_b -> true
        y_a == y_b and x_a < x_b -> true
        true -> false
      end
    end)
    #|> Map.to_list()
    |> Enum.each(fn 
      {{0,_}, 0} -> IO.write("\n" <> IO.ANSI.light_yellow() <> "0" <> IO.ANSI.white()) 
      {{_,_}, 0} -> IO.write(IO.ANSI.light_yellow() <> "0" <> IO.ANSI.white())
      {{0,_}, c} -> IO.write("\n" <> "#{c}")
      {{_,_}, c} -> IO.write(c)
    end)
  end

  defp flash(_, 100, acc), do: acc

  defp flash(octopus, i, acc) do
    # IO.write(IO.ANSI.clear())

    #octopus = octopus
    #|> Map.map(fn {_pos, c} -> c + 1 end)

    all = octopus
    |> Enum.map(fn {pos, _} -> pos end)

    {octopus, acc} = propagate(octopus, all, [], acc)
    #IO.write("\n\nIteration #{i + 1}")
    #print(octopus)
    #IO.write("\nFlashes: #{acc}")

    flash(octopus, i + 1, acc)
  end

  defp propagate([], [], handled, count) do 
    {handled 
    |> Enum.map(fn 
      {pos, :flash} -> {pos, 0}
      x -> x
    end), count}
  end

  defp propagate([], increase, handled, count) do 
    octopus = handled
    |> Enum.map(fn 
      {pos, :flash} -> {pos, :flash}
      {pos, energy} ->
        case Enum.filter(increase, fn p -> p == pos end) |> Enum.count do
          0 -> {pos, energy}
          n -> {pos, energy + n}
        end
    end)
    propagate(octopus, [], [], count)
  end

  defp propagate([{pos, energy} = head | tail], increase, handled, count) do
    case energy do
      :flash -> propagate(tail, increase, [head | handled], count)
      n when n > 9 -> propagate(tail, add_neighbours(pos, increase), [{pos, :flash} | handled], count + 1)
      _ -> propagate(tail, increase, [head | handled], count)
    end
  end

  defp add_neighbours({x, y}, increase) do
    [{-1, -1}, {0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}]
    |> Enum.map(fn {x_n, y_n} -> {x_n + x, y_n + y} end)
    #|> Enum.filter(fn {i, j} -> i < 0 or j < 0 end)
    |> Enum.reduce(increase, fn n, acc -> [n | acc] end)
  end

  def part2(args) do
    octopus = args
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {l, y} -> 
      l 
      |> String.graphemes 
      |> Enum.map(&String.to_integer/1) 
      |> Enum.with_index 
      |> Enum.map(fn {c, x} -> {{x, y}, c} end)
    end)
    #|> Enum.reduce(%{}, fn({k, v}, acc)-> Map.put(acc, k, v) end)

    res = all_flash(octopus, 0)
    res
  end

  defp all_flash(octopus, i) do
    all = octopus
    |> Enum.map(fn {pos, _} -> pos end)

    {octopus, _} = propagate(octopus, all, [], 0)
    cond do
      octopus |> Enum.all?(fn {_, energy} -> energy == 0 end) -> i + 1
      true -> all_flash(octopus, i + 1)
    end

  end
end
