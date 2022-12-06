input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

## Part 1

unique_chars_count = 4

## Part 2

unique_chars_count = 14

## common

input = input.(6) |> String.graphemes()

Enum.reduce_while(1..length(input), unique_chars_count, fn i, acc ->
  slice =
    input
    |> Enum.slice(i..(i + unique_chars_count - 1))
    |> MapSet.new()
    |> MapSet.size()

  if slice != unique_chars_count, do: {:cont, acc + 1}, else: {:halt, acc + 1}
end)
|> IO.inspect()
