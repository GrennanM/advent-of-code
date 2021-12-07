defmodule Utils do
  @day 4
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def lines() do
    {:ok, contents} = File.read(@input_path)
    [numbers | boards] = String.split(contents, "\n\n", trim: true)
    [String.split(numbers, ",") | boards]
  end

  # Credit: https://stackoverflow.com/a/23706084
  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end
end

defmodule Bingo do
  def get_boards(input) do
    input
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn y -> Enum.map(y, &String.split(&1, " ", trim: true)) end)
    |> Enum.reduce([], fn x, acc ->
      [%{rows: x, columns: Utils.transpose(x), numbers: MapSet.new(Enum.concat(x))} | acc]
    end)
  end

  def process_board(board, number) do
    if number in board[:numbers] do
      rows = Enum.map(board[:rows], fn x -> List.delete(x, number) end)
      cols = Enum.map(board[:columns], fn x -> List.delete(x, number) end)
      %{board | rows: rows, columns: cols}
    else
      board
    end
  end

  def board_has_won?(board) do
    [] in board[:rows] or [] in board[:columns]
  end
end

defmodule BingoPartOne do
  def solve() do
    [numbers | input] = Utils.lines()
    boards = Bingo.get_boards(input)

    {winning_board, number} = get_winning_board(boards, numbers)

    winning_board[:rows]
    |> Enum.concat()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> Kernel.*(number)
  end

  def get_winning_board(boards, numbers) do
    Enum.reduce_while(numbers, boards, fn number, boards ->
      new = Enum.map(boards, &Bingo.process_board(&1, number))

      case Enum.find(new, &Bingo.board_has_won?/1) do
        nil -> {:cont, new}
        board -> {:halt, {board, String.to_integer(number)}}
      end
    end)
  end
end

defmodule BingoPartTwo do
  def solve() do
    [numbers | input] = Utils.lines()
    boards = Bingo.get_boards(input)

    {[winning_board | _], number} = get_winning_board(boards, numbers)

    winning_board[:rows]
    |> Enum.concat()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> Kernel.*(number)
  end

  def get_winning_board(boards, numbers) do
    Enum.reduce_while(numbers, boards, fn number, boards ->
      new = Enum.map(boards, &Bingo.process_board(&1, number))

      case Enum.reject(new, &Bingo.board_has_won?/1) do
        [] -> {:halt, {new, String.to_integer(number)}}
        boards -> {:cont, boards}
      end
    end)
  end
end
