day = 3

inputs =
  (fn day -> Path.expand("./inputs/day_#{day}.txt") |> File.read!() end).(day)
  |> String.split("\n")

## Common

index_map =
  inputs
  |> Enum.with_index()
  |> Enum.flat_map(fn {row, row_index} ->
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {val, col_index} ->
      {{row_index, col_index}, val}
    end)
  end)
  |> Map.new()

## Part 1

non_symbols = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", nil]

inputs
|> Enum.with_index(fn row, row_index ->
  Regex.scan(~r/\b\d+\b/, row, return: :index)
  |> Enum.flat_map(fn [{starting_index, length}] -> [{starting_index, length}] end)
  |> Enum.zip(Regex.scan(~r/\b\d+\b/, row))
  |> Enum.flat_map(fn {{starting_index, length}, [number]} ->
    symbol_to_left = index_map[{row_index, starting_index - 1}] not in non_symbols
    symbol_to_right = index_map[{row_index, starting_index + length}] not in non_symbols

    symbol_above_or_below =
      Enum.any?((starting_index - 1)..(starting_index + length), fn col_index ->
        index_map[{row_index + 1, col_index}] not in non_symbols or
          index_map[{row_index - 1, col_index}] not in non_symbols
      end)

    if Enum.any?([symbol_above_or_below, symbol_to_left, symbol_to_right]) do
      [number]
    else
      []
    end
  end)
end)
|> List.flatten()
|> Enum.map(&String.to_integer/1)
|> Enum.sum()
|> IO.inspect()

## Part 2

inputs
|> Enum.with_index(fn row, row_index ->
  Regex.scan(~r/\b\d+\b/, row, return: :index)
  |> Enum.flat_map(fn [{starting_index, length}] -> [{starting_index, length}] end)
  |> Enum.zip(Regex.scan(~r/\b\d+\b/, row))
  |> Enum.flat_map(fn {{starting_index, length}, [number]} ->
    star_to_left =
      case index_map[{row_index, starting_index - 1}] do
        "*" -> [{row_index, starting_index - 1}]
        _ -> []
      end

    star_to_right =
      case index_map[{row_index, starting_index + length}] do
        "*" -> [{row_index, starting_index + length}]
        _ -> []
      end

    star_above =
      Enum.flat_map((starting_index - 1)..(starting_index + length), fn col_index ->
        case index_map[{row_index + 1, col_index}] do
          "*" -> [{row_index + 1, col_index}]
          _ -> []
        end
      end)

    star_below =
      Enum.flat_map((starting_index - 1)..(starting_index + length), fn col_index ->
        case index_map[{row_index - 1, col_index}] do
          "*" -> [{row_index - 1, col_index}]
          _ -> []
        end
      end)

    star_positions = star_above ++ star_below ++ star_to_left ++ star_to_right

    case star_positions do
      [] -> []
      _ -> [{star_positions, number}]
    end
  end)
end)
|> List.flatten()
|> Enum.map(fn {star_positions, number} ->
  Map.new(star_positions, fn star_position -> {star_position, [number]} end)
end)
|> Enum.reduce(%{}, fn x, acc ->
  Map.merge(x, acc, fn _k, v1, v2 -> v1 ++ v2 end)
end)
|> Enum.filter(fn {_k, v} -> length(v) == 2 end)
|> Enum.map(fn {_k, v} ->
  Enum.reduce(v, 1, fn i, acc -> String.to_integer(i) * acc end)
end)
|> Enum.sum()
|> IO.inspect()
