defmodule Utils do
  @day 3
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def lines() do
    {:ok, contents} = File.read(@input_path)
    String.split(contents, "\n", trim: true)
  end

  # Credit: https://stackoverflow.com/a/23706084
  def transpose([]), do: []
  def transpose([[] | _]), do: []

  def transpose(a) do
    [Enum.map(a, &hd/1) | transpose(Enum.map(a, &tl/1))]
  end

  def binary_to_decimal(number) do
    number
    |> Integer.parse(2)
    |> elem(0)
  end
end

defmodule BinaryDiagnostic do
  alias Utils

  def solve() do
    input = Utils.lines()

    count_of_ones =
      input
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
      |> Utils.transpose()
      |> Enum.map(&Enum.sum(&1))

    gamma =
      count_of_ones
      |> Enum.map(fn x -> if x >= length(input) / 2 do 1 else 0 end end)
      |> Enum.map_join(& &1)
      |> Utils.binary_to_decimal()

    epsilon =
      count_of_ones
      |> Enum.map(fn x -> if x < length(input) / 2 do 1 else 0 end end)
      |> Enum.map_join(& &1)
      |> Utils.binary_to_decimal()

    gamma * epsilon
  end
end

defmodule BinaryDiagnosticTwo do
  alias Utils

  def solve() do
    input = Utils.lines()

    oxygen_generator = get_number(input)
    co2_scrubber = get_number(input, false)

    oxygen_generator * co2_scrubber
  end

  def get_number(input, most_common \\ true, index \\ 0)

  def get_number(input, _, _) when length(input) == 1 do
    input
    |> hd()
    |> Utils.binary_to_decimal()
  end

  def get_number(input, most_common, index) do
    common_bit = get_common_bit(input, most_common, index)

    input
    |> Enum.filter(fn x -> String.at(x, index) == common_bit end)
    |> get_number(most_common, index + 1)
  end

  def get_common_bit(binary_numbers, most_common, index) do
    binary_numbers
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Utils.transpose()
    |> Enum.map(&Enum.sum(&1))
    |> Enum.map(fn x ->
      case most_common do
          true -> if x >= length(binary_numbers) / 2 do "1" else "0" end
          false -> if x < length(binary_numbers) / 2 do "1" else "0" end
        end
         end)
      |> Enum.at(index)
  end
end
