defmodule AdventOfCode.Day22 do
  def part1(args) do
    args
    |> parse
    |> Enum.reject( fn{_, {x_range, y_range, z_range}} ->
      Enum.any?([x_range, y_range, z_range], &(&1.first < -50 or &1.last > 50))
    end)
    |> flip_switches
    |> count_on
  end

  def part2(args) do
    args
    |> parse
    |> flip_switches
    |> count_on
  end

  defp flip_switches(instructions) do
    cubes = []
    instructions
    |> Enum.reduce(cubes, fn {action, new_cube}, cubes ->
        cubes = Enum.flat_map(cubes, fn old ->
          if overlaps?(old, new_cube) do
            cubeify(old, new_cube)
            |> Enum.reject(&(overlaps?(&1, new_cube)))
          else
            [old]
          end
        end)

        case action do
          :on -> [new_cube | cubes]
          :off -> cubes
        end
    end)
  end

  defp overlaps?({a_x, a_y, a_z}, {b_x, b_y, b_z}) do
    not Range.disjoint?(a_x, b_x) and not Range.disjoint?(a_y, b_y) and not Range.disjoint?(a_z, b_z)
  end

  defp cubeify(a, b), do: cubeify([a], b, 0)

  defp cubeify(cubes, _, 3), do: cubes
  defp cubeify(cubes, new, axis) do
    new_cubes = Enum.flat_map(cubes, &split(&1, new, axis))
    cubeify(new_cubes, new, axis + 1)
  end

  defp split(a, b, axis) do
    a_axis = elem(a, axis)
    b_axis = elem(b, axis)
    [a_axis.first..b_axis.first-1//1,
      max(a_axis.first, b_axis.first)..min(a_axis.last, b_axis.last)//1,
      min(a_axis.last, b_axis.last)+1..a_axis.last//1
    ]
    |> Enum.reject(&Range.size(&1) == 0)
    |> Enum.map(fn r ->
      put_elem(a, axis, r)
    end)
  end


  defp count_on(cubes) do
    cubes
    |> Enum.reduce(0, fn {x_range, y_range, z_range}, acc ->
      acc + (Range.size(x_range) * Range.size(y_range) * Range.size(z_range))
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [_, toggle, x_min, x_max, y_min, y_max, z_min, z_max] = Regex.run(~r/(on|off).*=(-?\d+)..(-?\d+).*=(-?\d+)..(-?\d+).*=(-?\d+)..(-?\d+)/, l)
      {String.to_atom(toggle), {to_coord(x_min, x_max), to_coord( y_min, y_max ), to_coord( z_min, z_max )}}
    end)
  end

  defp to_coord(a, b), do: Range.new(String.to_integer(a), String.to_integer(b))


end
