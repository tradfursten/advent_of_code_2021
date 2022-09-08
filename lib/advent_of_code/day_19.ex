defmodule AdventOfCode.Day19 do

  # translations and structure heavely inspired by https://github.com/mathsaey/adventofcode/blob/master/lib/2021/19.ex
  orientations = [
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],   # Unmodified
    [[1, 0, 0], [0, 0, -1], [0, 1, 0]],  # 90
    [[1, 0, 0], [0, -1, 0], [0, 0, -1]], # 180
    [[1, 0, 0], [0, 0, 1], [0, -1, 0]],  # 270
  ]
  rotations = [
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],   # Unmodified
    [[0, 1, 0], [-1, 0, 0], [0, 0, 1]],  # z 90
    [[-1, 0, 0], [0, -1, 0], [0, 0, 1]], # z 180
    [[0, -1, 0], [1, 0, 0], [0, 0, 1]],  # z 270
    [[0, 0, -1], [0, 1, 0], [1, 0, 0]],  # y 90
    [[0, 0, 1], [0, 1, 0], [-1, 0, 0]],  # y 270
    # y 180 is the same as z 180
  ]

  # Yes, there probably is a better way to generate this :)
  @translations (for rotation <- rotations, orientation <- orientations do
    # Multiply rotation matrix with orientation matrix
    transposed = orientation |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
    for row <- rotation do
      for col <- transposed do
        Enum.zip(row, col) |> Enum.map(fn {l, r} -> l * r end) |> Enum.sum()
      end
    end
  end)

  def part1(input) do
    input
    |> parse
    |> merge_scanners
    |> elem(0)
    |> MapSet.size
  end

  def part2(input) do
    input
    |> parse
    |> merge_scanners
    |> elem(1)
    |> distances
    |> Map.keys
    |> Enum.map(fn d -> Enum.map(d, &abs(&1)) |> Enum.sum end)
    |> Enum.max
  end

  defp merge_scanners([head | tail]), do: merge_scanners(MapSet.new(head), [[0, 0, 0]], tail)
  defp merge_scanners(merged, beacons, []), do: {merged, beacons}
  defp merge_scanners(merged_beacons, beacons, [scanner | scanners]) do
    distances = distances(merged_beacons)
    translations = all_translations(scanner)

    translations
    |> Enum.map(fn {translation, rotated_beacons} ->
      {translation, distances(rotated_beacons)}
    end)
    |> Stream.map(fn {translation, rotated_distances} ->
      {translation, matching_distances(distances, rotated_distances)}
    end)
    |> Enum.find(fn {_, matches} -> map_size(matches) >= 12 end)
    |> case do
      {translation, matching_distances} ->
        {distance, {scanner_beacon, _}} = matching_distances
        |> Enum.take(1)
        |> hd()

        range_distance = distance(scanner_beacon, elem(distances[distance], 0))

        scanner
        |> Enum.map(&translate(&1, translation))
        |> Enum.map(&distance(&1, range_distance))
        |> MapSet.new
        |> MapSet.union(merged_beacons)
        |> merge_scanners([range_distance | beacons], scanners)

      nil ->
        merge_scanners(merged_beacons, beacons, scanners ++ [scanner])
    end


  end

  defp matching_distances(distances, rotated_distances), do: Map.take(rotated_distances, Map.keys(distances))

  defp distances(beacons) do
    beacons
    |> Enum.flat_map(fn current_beacon ->
      beacons
      |> Enum.map(fn comparison_beacon ->
        {distance(current_beacon, comparison_beacon), {current_beacon, comparison_beacon}}
      end)
    end)
    |> Enum.reject(fn {_, {a, b}} -> a == b end)
    |> Map.new
  end

  defp distance([x, y, z], [a, b, c]), do: [x - a, y - b, z - c]


  defp all_translations(scanner) do
    @translations
    |> Enum.map(fn t ->
        {t, Enum.map(scanner, &translate(&1, t))}
    end)
  end

  defp translate(beacon, translation), do: Enum.map(translation, &dot(&1, beacon))

  defp dot(a, b) do
    Enum.zip(a, b)
    |> Enum.map(fn {l, r} -> l * r end)
    |> Enum.sum
  end

  defp parse(input) do
    input
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&tl/1)
    |> Enum.map(&parse_scanner/1)
  end

  defp parse_scanner(beacons) do
    beacons
    |> Enum.map(fn l ->
      l
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
