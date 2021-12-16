defmodule AdventOfCode.Day16 do

  use Bitwise
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&to_binary/1)
    #|> Enum.map(fn p -> p |> elem(0) |> count() end)
  end
  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&to_binary/1)
    |> Enum.map(fn p -> p |> elem(0) |> eval() end)
  end

  def to_binary(line) do
    IO.puts(line)
    line
    |> :binary.decode_hex
    |> parse_package
  end


  defp eval(n) when is_number(n), do: n 
  defp eval({_, 0, l}) when is_list(l), do: l |> Enum.map(&eval/1) |> Enum.sum()
  defp eval({_, 1, l}) when is_list(l), do: l |> Enum.map(&eval/1) |> Enum.product()
  defp eval({_, 2, l}) when is_list(l), do: l |> Enum.map(&eval/1) |> Enum.min()
  defp eval({_, 3, l}) when is_list(l), do: l |> Enum.map(&eval/1) |> Enum.max()
  defp eval({_, 5, [a, b]}), do: if(eval(a) > eval(b), do: 1, else: 0)
  defp eval({_, 6, [a, b]}), do: if(eval(a) < eval(b), do: 1, else: 0)
  defp eval({_, 7, [a, b]}), do: if(eval(a) == eval(b), do: 1, else: 0)
  defp eval({_, p}), do: eval(p)

  defp count(n) when is_number(n), do: 0
  defp count(l) when is_list(l), do: l |> Enum.map(&count/1) |> Enum.sum()
  defp count({v, _, p}), do: v + count(p)
  defp count({v, p}), do: v + count(p)
  defp count(_), do: 0

  defp parse_package(<<v::3, 4::3, bits::bits>>) do 
    {package, bits} = parse_literal(bits)
    {{v, package}, bits}
  end
  defp parse_package(<<v::3, id::3, 0::1, l::15, package_part::size(l), bits::bits>>) do 
    {{v, id, parse_packages(<<package_part::size(l)>>)}, bits}
  end
  defp parse_package(<<v::3, id::3, 1::1, l::11, bits::bits>>) do 
    {packages, bits} = parse_n_packages(bits, l)
    {{v, id, packages}, bits}
  end

  defp parse_literal(bits), do: parse_literal(bits, <<>>)
  defp parse_literal(<<1::1, x::4, bits::bits>>, res), do: parse_literal(bits, <<res::bits, x::4>>)
  defp parse_literal(<<0::1, x::4, bits::bits>>, res), do: {to_int(<<res::bits, x::4>>), bits}


  defp parse_n_packages(bits, 0), do: {[], bits}
  defp parse_n_packages(bits, n) do
    {package, bits} = parse_package(bits)
    {packages, bits} = parse_n_packages(bits, n - 1)
    {[package | packages], bits}
  end

  defp parse_packages(<<>>), do: []
  defp parse_packages(bits) do
    {p, bits} = parse_package(bits)
    [p | parse_packages(bits)]
  end

  defp to_int(bits) do
    s = bit_size(bits)
    <<int::size(s)>> = bits
    int
  end

end
