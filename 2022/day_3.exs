input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

values =
  [?a..?z, ?A..?Z]
  |> Enum.concat()
  |> Enum.zip(1..52)
  |> Map.new(fn {char, value} -> {<<char>>, value} end)

## Part 1

input.(3)
|> String.split("\n", trim: true)
|> Enum.map(&String.split_at(&1, div(String.length(&1), 2)))
|> Enum.map(fn {l, r} ->
  {
    l |> String.graphemes() |> MapSet.new(),
    r
  }
end)
|> Enum.flat_map(fn {l, r} ->
  Enum.map(l, fn char -> if String.contains?(r, char), do: char end)
end)
|> Enum.reject(&is_nil/1)
|> Enum.map(&values[&1])
|> Enum.sum()

## Part 2

input.(3)
|> String.split("\n", trim: true)
|> Enum.chunk_every(3)
|> Enum.flat_map(fn [a, b, c] ->
  s = a |> String.graphemes() |> MapSet.new()

  Enum.map(s, fn char ->
    if String.contains?(b, char) and String.contains?(c, char), do: char
  end)
end)
|> Enum.reject(&is_nil/1)
|> Enum.map(&values[&1])
|> Enum.sum()
