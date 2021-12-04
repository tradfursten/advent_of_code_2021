defmodule AdventOfCode.Day04 do
  def part1(args) do
    splitted = args |> String.split("\n")

    bingo_numbers = splitted
    |> Enum.at(0)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    bingo_boards = splitted
    |> Enum.drop(1)
    |> Enum.reject(fn s -> s == "" end)
    |> Enum.chunk_every(5)
    |> Enum.map(&parse_board/1)

    IO.inspect(bingo_numbers)
    IO.puts("Boards")
    IO.inspect(bingo_boards)

    winner = find_winner(bingo_boards, bingo_numbers)
    winner
  end

  defp parse_board(board) do
    board 
    |> Enum.map(fn s -> 
      s
      |> String.split(~r{\s}, trim: true)
      |> Enum.map(fn num ->
        {:unchecked, String.to_integer(num)}
      end)
    end)
  end

  defp find_winner(boards, [i | rest]) do
    boards = mark_number(boards, i)
    #IO.inspect(boards)
    board = boards |> Enum.filter(&bingo/1)
    case board do
      [] -> find_winner(boards, rest)
      [winning_board] -> 
        IO.puts("Winning number #{i}")
        get_score(winning_board, i)
    end
  end

  defp find_looser(boards, [i | rest]) do
    boards = mark_number(boards, i)
    board = boards |> Enum.filter(&bingo/1)
    IO.puts("All boards")
    IO.inspect(boards)
    IO.puts("Boards with bingo")
    IO.inspect(board)
    case board do
      [] -> find_looser(boards, rest)
      [winning_board] -> 
        #IO.puts("Winning number #{i}")
        #IO.inspect(boards)
        #IO.inspect(Enum.count(boards))
        cond do
          Enum.count(boards) == 1 ->
            get_score(winning_board, i)
          true ->
            find_looser(boards |> Enum.filter(fn b -> b != winning_board end), rest)
        end
      multiple ->
        find_looser(boards |> Enum.filter(fn b -> not Enum.any?(multiple, fn m -> m == b end) end), rest)
    end
  end

  defp mark_number(boards, number) do
    boards 
    |> Enum.map(fn board -> 
      board
      |> Enum.map(fn line -> 
        line
        |> Enum.map(fn {state, n} ->
          case n do
            ^number -> {:checked, n}
            _ -> {state, n}
          end
        end)
      end)
    end)
  end

  defp bingo(board) do
    bingo_row = board
    |> Enum.filter(fn r -> 
      r |> Enum.all?(fn {state, _n} -> state == :checked end)
    end)
    case Enum.empty?(bingo_row) do
      false -> true
      true -> bongo_col(board, 0)
    end
  end

  defp bongo_col(board, col) do
    number_cols = board |> Enum.at(0) |> Enum.count
    cond do
      number_cols > col -> 
        bingo? = board
        |> Enum.map(fn r -> Enum.at(r, col) end) 
        |> Enum.all?(fn {s, _i} -> s == :checked end)

        case bingo? do
          true -> true
          false -> bongo_col(board, col + 1)
        end
      true -> false
    end

  end

  defp get_score(board, num) do
    numbers_left = board
    |> Enum.map(fn r ->
      r 
      |> Enum.filter(fn {state, _n} -> state == :unchecked end)
      |> Enum.map(fn {_s, i} -> i end)
      |> Enum.sum
    end)
    |> Enum.sum

    numbers_left * num

  end

  def part2(args) do
    splitted = args |> String.split("\n")

    bingo_numbers = splitted
    |> Enum.at(0)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)

    bingo_boards = splitted
    |> Enum.drop(1)
    |> Enum.reject(fn s -> s == "" end)
    |> Enum.chunk_every(5)
    |> Enum.map(&parse_board/1)

    IO.inspect(bingo_numbers)
    IO.puts("Boards")
    IO.inspect(bingo_boards)

    find_looser(bingo_boards, bingo_numbers)
  end
end
