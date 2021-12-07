defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.sort(fn {a, av}, {b, bv} -> 
      if av == bv do
        a > b
      else 
        av > bv
      end
    end)
    |> initiate_fuel_count(&minimal_fuel/2)
  end

  defp initiate_fuel_count(crabs, fun) do
    {min, _} = crabs |> Enum.min_by(fn {_x, xv} -> xv end)
    {max, _} = crabs |> Enum.max_by(fn {_x, xv} -> xv end)

    min..max
    |> Enum.map(fn x -> fun.(crabs, x) end)
    |> Enum.min


  end

  defp minimal_fuel(crabs, target_position) do
    crabs
    |> Enum.map(fn {pos, count} -> 
      abs(pos - target_position) * count
    end)
    |> Enum.sum
  end

  defp minimal_fuel2(crabs, target_position) do
    crabs
    |> Enum.map(fn {pos, count} -> 
      (0..abs(pos - target_position) |> Enum.sum) * count
    end)
    |> Enum.sum
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> Map.to_list()
    |> Enum.sort(fn {a, av}, {b, bv} -> 
      if av == bv do
        a > b
      else 
        av > bv
      end
    end)
    |> initiate_fuel_count(&minimal_fuel2/2)
  end
end
