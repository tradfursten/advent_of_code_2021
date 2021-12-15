defmodule AdventOfCode.Day15 do
  def part1(args) do
    grid = args
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.flat_map(fn {l, y} ->
      l
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.map(fn {i, x} ->
        {{x, y}, String.to_integer(i)}
      end)
    end)
    |> Enum.reduce(%{}, fn {pos, v}, acc -> Map.put(acc, pos, v) end)

    risks = grid
    |> Map.keys
    |> Enum.reduce(%{}, fn pos, acc -> Map.put(acc, pos, -1) end)
    |> Map.put({0,0}, 0)

    risks = Map.put(%{}, {0,0}, 0)

    max = grid
    |> Map.keys
    |> Enum.max

    IO.inspect(max)

    res = bfs([{0,0}], risks, grid, max)

    Map.get(res, max)
    
  end

  defp bfs([], risks, _), do: risks

  defp bfs([goal | _], risks, _, goal), do: risks #Map.get(risks, goal)

  defp bfs([pos | tail], risks, grid, goal) do
    new_nodes = neighbours(pos)
    |> Enum.reject(&(Map.get(grid, &1) == nil))
    |> Enum.map(fn n -> 
      current_risk = Map.get(risks, pos) + Map.get(grid, n)
      case Map.get(risks, n) do
        nil -> {n, current_risk}
        v when v > current_risk -> {n, current_risk}
        _ -> :na
      end
    end)
    |> Enum.reject(fn 
      :na -> true
      _ -> false
    end)

    risks = new_nodes
    |> Enum.reduce(risks, fn {pos, risk}, acc -> Map.put(acc, pos, risk) end)

    queue = new_nodes
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.reduce(tail, fn i, acc -> [i | acc] end)
    |> Enum.sort_by(fn a -> Map.get(risks, a) end)

    bfs(queue, risks, grid, goal) 
  end


  defp neighbours({x, y}) do
    [{-1, 0}, {0, -1}, {1, 0}, {0, 1}]
    |> Enum.map(fn {x_n, y_n} -> {x_n + x, y_n + y} end)
    |> Enum.reject(fn {x, y} -> x < 0 or y < 0 end)
  end


  defp increase_risk(risk, i) do
    risk = risk + i
    if risk > 9, do: risk - 9, else: risk
  end

  def part2(args) do
    grid = args
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.flat_map(fn {l, y} ->
      l
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.map(fn {i, x} ->
        {{x, y}, String.to_integer(i)}
      end)
    end)
    |> Enum.reduce(%{}, fn {pos, v}, acc -> Map.put(acc, pos, v) end)

    print(grid)

    {x_max, y_max} = grid |> Map.keys |> Enum.max
    width = x_max + 1
    height = y_max + 1



    grid = grid
    |> Enum.reduce(grid, fn {{x, y}, risk}, grid -> 
      Enum.reduce(1..4, grid, fn index, grid ->
        Map.put(grid, {x + index * width, y}, increase_risk(risk, index))
      end)
    end)
    new_grid = grid
    |> Enum.reduce(grid, fn {{x, y}, risk}, grid -> 
      Enum.reduce(1..4, grid, fn index, grid ->
        Map.put(grid, {x, y + index * height}, increase_risk(risk, index))
      end)
    end)


   # new_grid = for y_i <- 0..4, x_i <- 0..4 do
   #   grid
   #   |> Map.to_list
   #   |> Enum.map(fn {{x, y}, v} -> 
   #     r = 1 + rem((v - 1 + y_i + x_i), 9)
   #     {{x + x_i * x_max, y + y_i * y_max}, r}
   #   end)
   # end
   # |> Enum.reduce(%{}, fn sub_grid, acc -> 
   #   sub_grid
   #   |> Enum.reduce(acc, fn {pos, v}, sub_acc -> Map.put(sub_acc, pos, v) end)
   # end)

    print(new_grid)

    risks = Map.put(%{}, {0,0}, 0)

    max = new_grid
    |> Map.keys
    |> Enum.max

    IO.inspect(max)

    res = bfs([{0,0}], risks, new_grid, max)

    Map.get(res, max)
  end

  defp print(grid) do
    {x_max, y_max} = grid
    |> Map.keys
    |> Enum.max

    IO.puts("\n-----")
    for y <- 0..y_max, x <- 0..x_max do 
      if x == 0, do: IO.write("\n")
      IO.write(Map.get(grid, {x, y}))
    end
    IO.puts("\n-------")
  end

end
