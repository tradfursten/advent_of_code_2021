defmodule AdventOfCode.Day21 do
  def part1({p1, p2}) do
    players = {p1, p2}
    game_on(players)
  end


  defp game_on(players, dice \\ {0,0}, score \\ {0,0})
  defp game_on({p1, p2}, dice, {score_1, score_2}) do
    {p1, dice, score_1} = take_turn(p1, dice, score_1, 1)
    if score_1 > 1000 do
        IO.puts("Player 1 won #{score_1} rolls => #{Enum.min([score_1, score_2])} * #{elem(dice,1)}")
      score_2 * elem(dice,1)
    else
      {p2, dice, score_2} = take_turn(p2, dice, score_2, 2)
      if score_2 > 1000 do
        IO.puts("Player 2 won #{score_2} rolls => #{Enum.min([score_1, score_2])} * #{elem(dice,1)}")
        score_1 * elem(dice,1)
      else
        game_on({p1, p2}, dice, {score_1, score_2})
      end
    end
  end

  defp take_turn(pos, {_, current_rolls} = dice_pos, score, player) do
    {face, rolls} = dice_take(dice_pos)# |> IO.inspect
    dice_pos = face
    throws = rolls |> Enum.join("+")
    pos = get_pos(pos + (rolls |> Enum.sum))
    IO.puts("Player #{player} rolls #{throws} moves to #{pos} for a total score of #{score + pos}")
    {pos, {dice_pos, Enum.count(rolls) + current_rolls}, score + pos}
  end

  defp dice_take(die, n \\ 3) do
    1..n
    |> Enum.reduce({elem(die, 0), []}, fn _, die ->
      roll(die)
    end)
  end

  defp roll({face, rolls}) do
    face = rem(face, 100) + 1
    {face, [face | rolls]}
  end


  defp get_pos(x) do
    rem(x - 1, 10) + 1
  end

  @moves for(i<-1..3, j <-1..3, k <-1..3, do: i + j + k) |> Enum.frequencies() |> Enum.to_list

  defp turn({_, {_, score}}) when score >= 21, do: {0, 1}

  defp turn({current_player, other_player}) do
    @moves
    |> Enum.map(fn {steps, freq} ->
      {other_player_wins, current_player_wins} = turn({other_player, update(current_player, steps)})
      {freq * current_player_wins, freq * other_player_wins}
    end)
    |> Enum.reduce(fn {results_1, results_2}, {acc_1, acc_2} -> {results_1 + acc_1, results_2 + acc_2} end)
  end

  defp update({player, score}, steps) do
    new_pos = rem(player + steps - 1, 10) + 1
    {new_pos, score + new_pos}
  end

  def part2({p1, p2}) do
    {{p1, 0}, {p2, 0}}
    |> turn
  end
end
