defmodule AdventOfCode.Day13 do

  def part1(args) do
      input = args
    |> String.split("\n", trim: true)

    dots = input
    |> Enum.take_while(fn l -> not String.starts_with?(l, "fold") end)
    |> Enum.map(fn l -> 
        l
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    |> Enum.reduce(%{}, fn pos, acc -> Map.put(acc, pos, "#") end)

    fold = input
    |> Enum.reject(fn l -> not String.starts_with?(l, "fold") end)
    |> Enum.map(fn l ->
        m = Regex.scan(~r/(x|y)=(\d+)/, l) |> Enum.at(0)
      {Enum.at(m, 1), Enum.at(m, 2) |> String.to_integer}
    end)
    |> Enum.at(0)

    fold(dots, [fold])
    |> Map.values
    |> Enum.count
  end

  defp fold(dots, []), do: dots
  defp fold(dots, [{axis, v} | tail]) do
      # IO.puts("\n#{axis} #{v}")
    dots
    |> Map.to_list
    |> Enum.reject(fn {_pos, c} -> "#" != c end)
    |> Enum.map(fn {{x, y}, _} ->
        case axis do
          "x" ->
            cond do
              x > v -> {{v * 2 - x, y}, "#"}
            true -> {{x, y}, "#"}
          end
        "y" ->
            cond do
              y > v -> {{x, v * 2 - y}, "#"}
            true -> {{x, y}, "#"}
          end
      end
    end)
    |> Enum.reduce(%{}, fn {pos, c}, acc -> Map.put(acc, pos, c) end)
    |> fold(tail)
  end

  def part2(args) do
      input = args
    |> String.split("\n", trim: true)

    dots = input
    |> Enum.take_while(fn l -> not String.starts_with?(l, "fold") end)
    |> Enum.map(fn l -> 
        l
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
    |> Enum.reduce(%{}, fn pos, acc -> Map.put(acc, pos, "#") end)

    # IO.inspect(dots)

    folds = input
    |> Enum.reject(fn l -> not String.starts_with?(l, "fold") end)
    |> Enum.map(fn l ->
        m = Regex.scan(~r/(x|y)=(\d+)/, l) |> Enum.at(0)
      {Enum.at(m, 1), Enum.at(m, 2) |> String.to_integer}
    end)
    # print(dots)
    code = fold(dots, folds)
    print(code)
  end

  defp print(code) do
      {x_m, y_m} = code
    |> Map.keys
    |> Enum.reduce({0,0}, fn {x,y}, {max_x, max_y} ->
        {max(x, max_x), max(y, max_y)}
    end)

    for y <- 0..(y_m + 2), x <- 0..(x_m + 1) do
        if x == 0, do: IO.write("\n")
      IO.write(Map.get(code, {x,y}, "."))
    end

  end
end
