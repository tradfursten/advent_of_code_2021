defmodule AdventOfCode.Day18 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&Code.string_to_quoted!/1)
    |> Enum.reduce([], fn 
      x, [] -> x
      x, acc -> 
        [acc, x] |> reduce()
    end)
    |> magnitude()
  end

  def part2(args) do
    numbers = args
    |> String.split("\n", trim: true)
    |> Enum.map(&Code.string_to_quoted!/1)

    all_numbers = for x <- numbers, y <- numbers, x != y, do: [x, y]

    all_numbers
    |> Enum.map(fn l ->
      l
      |> reduce()
      |> magnitude()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(1)
  end
  def reduce(number) do
    explode_or_split(number)
  end

  defp explode_or_split(tree) do
    IO.inspect(tree, binaries: :as_binaries)
    with tree when is_list(tree) <- explode(tree, 0),
         tree when is_list(tree) <- split(tree) do
      tree
    else
      {:explode, tree, _, _} -> 
        IO.write("Explode! ")
        IO.inspect(tree)
        explode_or_split(tree)
      {:split, tree} -> 
        IO.write("Split! ")
        IO.inspect(tree)
        explode_or_split(tree)
    end
  end

  defp explode([l, r], 4) when is_number(l) and is_number(r), do: {:explode, 0, l, r}

  defp explode([l, r], d) do
    with {:left, l} when not is_tuple(l) <- {:left, explode(l, d + 1)},
         {:right, r} when not is_tuple(r) <- {:right, explode(r, d + 1)} do
        [l, r]
    else
      {:left, {:explode, l, add_l, add_r}} ->
        {r, add_r} = add(r, add_r, :left)
        {:explode, [l, r], add_l, add_r}
      {:right, {:explode, r, add_l, add_r}} ->
        {l, add_l} = add(l, add_l, :right)
        {:explode, [l, r], add_l, add_r}
    end
  end
  defp explode(x, _), do: x

  defp split([l, r]) do
    with {:left, l} when not is_tuple(l) <- {:left, split(l)},
         {:right, r} when not is_tuple(r) <- {:right, split(r)} do
      [l, r]
    else
      {:left, {:split, l}} -> {:split, [l, r]}
      {:right, {:split, r}} -> {:split, [l, r]}
    end
  end
  defp split(x) when x > 9, do: {:split, [div(x, 2), x - div(x, 2)]}
  defp split(x), do: x


  defp add(any, nil, _), do: {any, nil}
  defp add(x, v, _) when is_number(x), do: {x + v, nil}
  defp add([l, r], v, :left) do
    {l, v} = add(l, v, :left)
    {[l, r], v}
  end
  defp add([l, r], v, :right) do
    {r, v} = add(r, v, :right)
    {[l, r], v}
  end

  defp magnitude(x) when is_number(x), do: x
  defp magnitude([l, r]) when is_number(l) and is_number(r), do: l * 3 + r * 2
  defp magnitude([l, r]) when is_list(l) or is_list(r), do: magnitude([magnitude(l), magnitude(r)])


end
