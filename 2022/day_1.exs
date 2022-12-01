input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  {:ok, contents} = File.read(path)

  contents
end

## Part One

input.(1)
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(
  &Enum.reduce(&1, 0, fn cal, acc ->
    String.to_integer(cal) + acc
  end)
)
|> Enum.sort(:desc)
|> hd()

## Part Two

input.(1)
|> String.split("\n\n")
|> Enum.map(&String.split(&1, "\n"))
|> Enum.map(
  &Enum.reduce(&1, 0, fn cal, acc ->
    String.to_integer(cal) + acc
  end)
)
|> Enum.sort(:desc)
|> Enum.take(3)
|> Enum.sum()
