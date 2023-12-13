day = 4

inputs =
  (fn day -> Path.expand("./inputs/day_#{day}.txt") |> File.read!() end).(day)
  |> String.split("\n")

defmodule Helper do
  def parse_inputs(inputs) do
    inputs
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.flat_map(fn x -> Enum.map(x, &String.split(&1, "| ")) end)
    |> Enum.drop_every(2)
  end

  def get_matching_numbers_count([winning_numbers, my_numbers]) do
    my_numbers = parse_numbers(my_numbers)

    parse_numbers(winning_numbers)
    |> Enum.filter(fn n -> MapSet.member?(my_numbers, n) end)
    |> Enum.count()
  end

  def build_board(board, row_number \\ 1) do
    {row, row_count} = Map.fetch!(board, row_number)
    matching_numbers_count = get_matching_numbers_count(row)

    new_board =
      if matching_numbers_count == 0 do
        board
      else
        Map.new((row_number + 1)..(row_number + matching_numbers_count), fn i ->
          {row, old_count} = Map.fetch!(board, i)
          {i, {row, old_count + row_count}}
        end)
        |> Map.merge(board, fn _k, v1, _v2 -> v1 end)
      end

    if Map.has_key?(new_board, row_number + 1) do
      build_board(new_board, row_number + 1)
    else
      new_board
    end
  end

  defp parse_numbers(numbers) do
    numbers
    |> String.split(" ")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end
end

## Part 1

inputs
|> Helper.parse_inputs()
|> Enum.map(&Helper.get_matching_numbers_count/1)
|> Enum.reject(&(&1 == 0))
|> Enum.map(fn n -> 2 ** (n - 1) end)
|> Enum.sum()
|> IO.inspect()

## Part 2

inputs
|> Helper.parse_inputs()
|> Enum.with_index()
|> Map.new(fn {row, row_number} -> {row_number, {row, 1}} end)
|> Helper.build_board()
|> Map.values()
|> Enum.map(fn {_row, count} -> count end)
|> Enum.sum()
|> IO.inspect()
