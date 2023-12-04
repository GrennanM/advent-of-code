day = 2

inputs =
  (fn day -> Path.expand("./inputs/day_#{day}.txt") |> File.read!() end).(day)
  |> String.split("\n")

## Part One

parse_set = fn set ->
  Enum.map(set, fn s ->
    [n, colour] = String.split(s)
    count = String.to_integer(n)

    case colour do
      "red" -> count <= 12
      "green" -> count <= 13
      "blue" -> count <= 14
    end
  end)
end

inputs
|> Map.new(fn s ->
  [n, games] =
    s
    |> String.trim_leading("Game ")
    |> String.split(": ", trim: true)

  {String.to_integer(n), String.split(games, "; ", trim: true)}
end)
|> Enum.flat_map(fn {n, games} ->
  is_possible? =
    games
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.flat_map(&parse_set.(&1))
    |> Enum.all?()

  if is_possible? do
    [n]
  else
    []
  end
end)
|> Enum.sum()

## Part Two

parse_set = fn set ->
  Enum.map(set, fn s ->
    [n, colour] = String.split(s, " ", trim: true)
    {colour, String.to_integer(n)}
  end)
end

inputs
|> Enum.map(fn s ->
  [_, games] = String.split(s, ": ")

  String.split(games, "; ", trim: true)
  |> Enum.map(&String.split(&1, ",", trim: true))
  |> Enum.flat_map(&parse_set.(&1))
  |> Enum.reduce(%{}, fn {colour, count}, acc ->
    current_max = Map.get(acc, colour, 0)

    if count > current_max do
      Map.put(acc, colour, count)
    else
      acc
    end
  end)
  |> Map.values()
  |> Enum.reduce(fn x, acc -> x * acc end)
end)
|> Enum.sum()
