input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

## Part 1

input.(4)
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, [",", "-"]))
|> Enum.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
|> Enum.filter(fn [a, b, c, d] ->
  (a >= c and b <= d) or (c >= a and d <= b)
end)
|> Enum.count()

## Part 2

input.(4)
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, [",", "-"]))
|> Enum.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
|> Enum.filter(fn [a, b, c, d] ->
  (a >= c and a <= d) or
    (b >= c and b <= d) or
    (c >= a and c <= b) or
    (d >= a and d <= b)
end)
|> Enum.count()
