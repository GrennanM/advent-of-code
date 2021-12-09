defmodule Utils do
  @day 6
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def initial_state() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Lanternfish do
  @number_of_days 80

  def solve() do
    Utils.initial_state()
    |> count(@number_of_days)
  end

  def count(input, 0), do: length(input)

  def count(input, days) do
    input
    |> Enum.flat_map(&handle/1)
    |> count(days - 1)
  end

  def handle(n) when n == 0 do [6, 8] end
  def handle(n), do: [n - 1]
end

defmodule LanternfishTwo do
  @number_of_days 256

  def solve() do
    inputs =
      Utils.initial_state()
      |> Enum.frequencies()

    base =
      Enum.zip(0..8, List.duplicate(0, 9))
      |> Map.new(fn {k, v} -> {k, v} end)
      |> Map.merge(inputs)

    handle(base, @number_of_days)
    |> Map.values()
    |> Enum.sum()
  end

  def handle(base, 0), do: base

  def handle(base, n) do
    new_fish = base[0]
    {_, map_without_8} = Map.pop(base, 8)
    updated_map = for {k, v} <- map_without_8, into: %{}, do: {k, base[k + 1]}

    updated_map
    |> Map.update!(6, &(&1 + new_fish))
    |> Map.put(8, new_fish)
    |> handle(n - 1)
  end
end
