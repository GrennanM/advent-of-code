input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

scores = %{"X" => 1, "Y" => 2, "Z" => 3}

## Part 1

input.(2)
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, " "))
|> Enum.reduce(0, fn [_elf, me] = output, acc ->
  object_score = scores[me]

  case output do
    # draw
    ["A", "X"] -> acc + object_score + 3
    ["B", "Y"] -> acc + object_score + 3
    ["C", "Z"] -> acc + object_score + 3
    # I won
    ["A", "Y"] -> acc + object_score + 6
    ["B", "Z"] -> acc + object_score + 6
    ["C", "X"] -> acc + object_score + 6
    # I lost
    _ -> acc + object_score
  end
end)

## Part 2

result = %{"X" => "lose", "Y" => "draw", "Z" => "win"}
elf = ["A", "B", "C"]
me = ["X", "Y", "Z"]

winning_order = for i <- 0..2, do: Enum.at(me, rem(i + 1, 3))
losing_order = for i <- 0..2, do: Enum.at(me, rem(i + 2, 3))

# what did I play to win/lose/draw?
winning_mapper = Enum.zip(elf, winning_order) |> Map.new()
losing_mapper = Enum.zip(elf, losing_order) |> Map.new()
draw_mapper = Enum.zip(elf, me) |> Map.new()

input.(2)
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, " "))
|> Enum.reduce(0, fn [elf, output], acc ->
  case result[output] do
    "win" -> acc + Map.fetch!(scores, winning_mapper[elf]) + 6
    "lose" -> acc + Map.fetch!(scores, losing_mapper[elf])
    _ -> acc + Map.fetch!(scores, draw_mapper[elf]) + 3
  end
end)
