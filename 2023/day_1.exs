day = 1

inputs = (fn day -> Path.expand("./inputs/day_#{day}.txt") |> File.read!() end).(day)

## Part One

inputs
|> String.split("\n")
|> Enum.map(&String.replace(&1, ~r/([a-z])/, ""))
|> Enum.map(&String.to_integer/1)
|> Enum.map(&Integer.digits/1)
|> Enum.map(fn
  i when is_integer(i) -> i * 10 + i
  i -> hd(i) * 10 + List.last(i)
end)
|> Enum.sum()
|> IO.inspect()

## Part Two

digits = %{
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

digits_rev = Map.new(digits, fn {s, i} -> {String.reverse(s), i} end)

first =
  inputs
  |> String.split("\n")
  |> Enum.map(&String.replace(&1, Map.keys(digits), fn i -> "#{digits[i]}" end, global: false))
  |> Enum.map(&String.replace(&1, ~r/([a-z])/, ""))
  |> Enum.map(&String.first/1)
  |> Enum.map(&(String.to_integer(&1) * 10))

inputs
|> String.split("\n")
|> Enum.map(&String.reverse/1)
|> Enum.map(
  &String.replace(&1, Map.keys(digits_rev), fn i -> "#{digits_rev[i]}" end, global: false)
)
|> Enum.map(&String.replace(&1, ~r/([a-z])/, ""))
|> Enum.map(&String.first/1)
|> Enum.map(&String.to_integer/1)
|> Enum.zip_reduce(first, 0, fn l, f, acc -> acc + f + l end)
|> IO.inspect()
