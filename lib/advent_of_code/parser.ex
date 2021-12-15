defmodule AdventOfCode.Parser do


    def parse_lines_with_integers(args) do
        args
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&parse_integers/1)
    end

    def parse_integers(line) do
      ~r/\d+/
      |> Regex.scan(line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
    
    end
end
