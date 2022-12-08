input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

grid =
  input.(8)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.graphemes/1)
  |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

## Part 1

Enum.flat_map(1..(length(grid) - 2), fn x ->
  Enum.map(1..(length(grid) - 2), fn y ->
    current_value = Enum.at(grid, x) |> Enum.at(y)
    {left, right} = grid |> Enum.at(x) |> Enum.split(y)
    {above, below} = grid |> Enum.map(&Enum.at(&1, y)) |> Enum.split(x)

    if Enum.all?(left, &(&1 < current_value)) or
         Enum.all?(tl(right), &(&1 < current_value)) or
         Enum.all?(above, &(&1 < current_value)) or
         Enum.all?(tl(below), &(&1 < current_value)) do
      1
    else
      0
    end
  end)
end)
|> Enum.sum()
|> Kernel.+((length(grid) - 1) * 4)
|> IO.inspect()

# ## Part 2

get_score = fn row, current_value ->
  Enum.reduce_while(row, 0, fn x, acc ->
    if x < current_value, do: {:cont, acc + 1}, else: {:halt, acc + 1}
  end)
end

grid =
  input.(8)
  |> String.split("\n", trim: true)
  |> Enum.map(&String.graphemes/1)
  |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))

Enum.flat_map(1..(length(grid) - 2), fn x ->
  Enum.map(1..(length(grid) - 2), fn y ->
    current_value = Enum.at(grid, x) |> Enum.at(y)
    {above, below} = grid |> Enum.map(&Enum.at(&1, y)) |> Enum.split(x)
    {left, right} = grid |> Enum.at(x) |> Enum.split(y)

    above_score = above |> Enum.reverse() |> get_score.(current_value)
    below_score = below |> tl() |> get_score.(current_value)
    left_score = left |> Enum.reverse() |> get_score.(current_value)
    right_score = right |> tl() |> get_score.(current_value)

    left_score * right_score * above_score * below_score
  end)
end)
|> Enum.max()
|> IO.inspect()
