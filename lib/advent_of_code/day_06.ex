defmodule AdventOfCode.Day06 do
  def part1(args, days) do
      args
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    |> breed_fish(days)
    |> Enum.count()
  end


  def part2(args, days) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> breed_fish_2(days)

  end

  defp breed_fish(fish, 0) do
    fish
  end

  defp breed_fish(fish, days) do
    new_fishes = fish
    |> Enum.reduce([], fn 
      0, acc -> [6| [8| acc]]
      i, acc -> [i - 1 | acc]
    end)

    breed_fish(new_fishes, days - 1)
  end

  defp breed_fish_2(fish, 0), do: fish |> Map.values |> Enum.sum()

  defp breed_fish_2(fish, days) do
    fish
    |> Map.pop(0)
    |> fn {x, fish} -> 
      Map.merge(
        for({c, v} <- fish, into: %{}, do: {c - 1, v}),
        %{6 => x || 0, 8 => x || 0},
        fn _, a, b -> a + b end
      )
    end.()
    |> breed_fish_2(days - 1)

  end
  
end
