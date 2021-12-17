defmodule AdventOfCode.Day17 do
  def part1(args) do
    [_, _, y_min, _] = Regex.scan(~r/-?\d+/, args)
    |> Enum.flat_map(fn l -> l |> Enum.map(&String.to_integer/1) end)

    div(y_min * (y_min + 1), 2)
  end

  def part2(args) do
    [x_min, x_max, y_min, y_max] = Regex.scan(~r/-?\d+/, args)
    |> Enum.flat_map(fn l -> l |> Enum.map(&String.to_integer/1) end)
    s = {0,0}

    launch(s, {x_min, y_max}, {x_max, y_min})
  end

  defp launch(s, t_0, t_1) do

    for x <- -500..500, y <- -500..500 do
      {hit_or_miss(s, {x, y}, t_0, t_1), {x, y}}
    end
    |> Enum.reject(fn 
      {:hit, _} -> false
      {:miss, _} -> true
    end)
    |> Enum.uniq
    |> Enum.count
  end

  defp hit_or_miss({x, y}, {v_x, v_y}, {t_0_x, t_0_y} = t_0, {t_1_x, t_1_y} = t_1) do
    {x, y} = {x + v_x, y + v_y}
    cond do
      x in t_0_x..t_1_x and y in t_0_y..t_1_y -> :hit
      x > t_1_x or y < t_1_y -> :miss
      true -> hit_or_miss({x, y}, {max(v_x - 1, 0), v_y - 1}, t_0, t_1)
    end
  end

end
