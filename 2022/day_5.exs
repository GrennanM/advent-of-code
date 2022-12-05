input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

## common setup

[crates, moves] =
  input.(5)
  |> String.split("\n\n", trim: true)
  |> Enum.map(&String.split(&1, "\n", trim: true))

crates =
  crates
  |> Enum.map(&String.replace(&1, "    ", "[.]"))
  |> Enum.map(&String.replace(&1, [" ", "[", "]"], "", trim: true))
  |> Enum.map(&String.graphemes/1)
  |> Enum.zip_with(& &1)
  |> Enum.map(&Enum.filter(&1, fn x -> Regex.match?(~r/[A-Z]/, x) end))

moves =
  moves
  |> Enum.map(&String.split/1)
  |> Enum.map(&tl/1)
  |> Enum.map(&Enum.take_every(&1, 2))
  |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

## Part 1

move_one = fn [count, from, to], crates ->
  {crates_to_move, row_w_crates_removed} = crates |> Enum.at(from - 1) |> Enum.split(count)
  row_w_new_crates = Enum.reverse(crates_to_move) ++ Enum.at(crates, to - 1)

  crates
  |> List.replace_at(from - 1, row_w_crates_removed)
  |> List.replace_at(to - 1, row_w_new_crates)
end

moves
|> Enum.reduce(crates, fn move, acc -> move_one.(move, acc) end)
|> Enum.map(&hd/1)
|> Enum.join()
|> IO.inspect()

## Part 2

move_many = fn [count, from, to], crates ->
  {crates_to_move, row_w_crates_removed} = crates |> Enum.at(from - 1) |> Enum.split(count)
  row_w_new_crates = crates_to_move ++ Enum.at(crates, to - 1)

  crates
  |> List.replace_at(from - 1, row_w_crates_removed)
  |> List.replace_at(to - 1, row_w_new_crates)
end

moves
|> Enum.reduce(crates, fn move, acc -> move_many.(move, acc) end)
|> Enum.map(&hd/1)
|> Enum.join()
|> IO.inspect()
