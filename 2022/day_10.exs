input = fn day ->
  path = Path.expand("./inputs/day_#{day}.txt")
  File.read!(path)
end

## Part 1

input.(10)
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, " ", trim: true))
|> Enum.reduce([1], fn op, [current | _] = acc ->
  case op do
    ["noop"] -> [current | acc]
    ["addx", val] -> [current + String.to_integer(val), current | acc]
  end
end)
|> Enum.reverse()
|> Enum.with_index(1)
|> Enum.filter(fn {_, cycle} -> cycle in [20, 60, 100, 140, 180, 220] end)
|> Enum.map(fn {val, cycle} -> val * cycle end)
|> Enum.sum()
|> IO.inspect()


## Part 2

input.(10)
|> String.split("\n", trim: true)
|> Enum.map(&String.split(&1, " ", trim: true))
|> Enum.reduce([1], fn op, [current | _] = acc ->
  case op do
    ["noop"] -> [current | acc]
    ["addx", val] -> [current + String.to_integer(val), current | acc]
  end
end)
|> Enum.reverse()
|> Enum.with_index(1)
|> Enum.reduce([], fn {register, cycle}, acc ->
  cycle = rem(cycle, 40)
  if cycle >= register and cycle <= register + 2 do
    ["#" | acc]
  else
    ["." | acc]
  end
end)
|> Enum.reverse()
|> Enum.chunk_every(40)
|> Enum.join("\n")
|> IO.puts()
