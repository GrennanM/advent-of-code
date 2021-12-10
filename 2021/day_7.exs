defmodule Utils do
  @day 7
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def initial_state() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end

defmodule Crabs do
  def solve() do
    crabs = Utils.initial_state()
    {min, max} = Enum.min_max(crabs)

    Enum.map(min..max, &get_fuel(crabs, &1))
    |> Enum.min()
  end

  def get_fuel(crabs, position) do
    Enum.reduce(crabs, 0, fn x, acc -> acc + abs(position - x) end)
  end
end

defmodule CrabsTwo do
  def solve() do
    crabs = Utils.initial_state()
    {min, max} = Enum.min_max(crabs)

    Enum.map(min..max, &get_fuel(crabs, &1))
    |> Enum.min()
  end

  def get_fuel(crabs, position) do
    Enum.reduce(crabs, 0, fn x, acc -> acc + get_triangular_number(abs(position - x)) end)
  end

  def get_triangular_number(n), do: n * (n + 1) / 2
end
