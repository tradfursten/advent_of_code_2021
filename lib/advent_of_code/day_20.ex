defmodule AdventOfCode.Day20 do
  def part1(args) do
    [enhancer, image] = args
    |> String.split("\n\n", trim: true)

    image = image
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {l, y}, acc ->
      l
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(acc, fn {c, x}, acc ->
        c = if c == "#", do: 1, else: 0
        Map.put(acc, {x, y}, c)
      end)
    end)

    enhancer = String.split(enhancer, "", trim: true)
    |> Enum.map(fn c -> if c == "#", do: 1, else: 0 end)

    # img = 0..1
    # |> Enum.reduce(image, fn i, img ->
    #   enhance(img, enhancer, i)
    # end)

    img = Stream.iterate({image, enhancer, 0}, &enhance/1)
    |> Enum.at(2)
    |> elem(0)

     IO.puts("End result")
     print(img, 0)
     img
     |> Map.values
     |> Enum.reject(fn 0 -> true
       _ -> false
     end)
     |> Enum.count()
  end


  defp enhance({img, enhancer, default}) do
    IO.puts("Enhance")
    {min, max} = img
    |> Map.keys
    |> Enum.min_max

    {x_min, y_min} = {elem(min,0) - 1, elem(min, 1) - 1}
    {x_max, y_max} = {elem(max,0) + 1, elem(max, 1) + 1}

    bg = if default == 0, do: 511, else: 0
    IO.puts("#{default} #{bg}")
    default = Enum.at(enhancer, bg)

    #print(img, default)

    img = for y <- y_min..y_max, x <- x_min..x_max  do
      s = neighbour_value(x, y, img, default)
      {{x, y}, Enum.at(enhancer, s)}
    end
    |> Enum.into(%{})
    {img, enhancer, bg}
  end

  defp neighbour_value(x, y, img, default) do
    for i <- -1..1, j <- -1..1 do
      Map.get(img, {x + j, y + i}, default)
    end
    |> Integer.undigits(2)
  end

  def part2(args) do
    [enhancer, image] = args
    |> String.split("\n\n", trim: true)

    image = image
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {l, y}, acc ->
      l
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(acc, fn {c, x}, acc ->
        c = if c == "#", do: 1, else: 0
        Map.put(acc, {x, y}, c)
      end)
    end)

    enhancer = String.split(enhancer, "", trim: true)
    |> Enum.map(fn c -> if c == "#", do: 1, else: 0 end)

    # img = 0..1
    # |> Enum.reduce(image, fn i, img ->
    #   enhance(img, enhancer, i)
    # end)

    img = Stream.iterate({image, enhancer, 0}, &enhance/1)
    |> Enum.at(50)
    |> elem(0)

     IO.puts("End result")
     print(img, 0)
     img
     |> Map.values
     |> Enum.reject(fn 0 -> true
       _ -> false
     end)
     |> Enum.count()
  end

  defp print(img, default) do
    {min, max} = img
    |> Map.keys
    |> Enum.min_max

    {x_min, y_min} = {elem(min,0) - 5, elem(min, 1) - 5}
    {x_max, y_max} = {elem(max,0) + 5, elem(max, 1) + 5}
    IO.write("\n-----\n")
    for y <- y_min..y_max, x <- x_min..x_max  do
      if x == x_min, do: IO.write("\n")
      case Map.get(img, {x,y}, default) do
        1 -> "#"
        0 -> "."
      end
      |> IO.write
    end
    IO.write("\n-----\n")
  end
end
