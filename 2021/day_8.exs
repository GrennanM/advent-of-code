defmodule Utils do
  @day 8
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def lines() do
    {:ok, contents} = File.read(@input_path)
    String.split(contents, "\n", trim: true)
  end
end

defmodule SevenSegment do
  def solve() do
    Utils.lines()
    |> Enum.flat_map(&split_and_trim_left/1)
    |> Enum.flat_map(&String.split(&1, " "))
    |> Enum.filter(fn x -> String.length(x) in MapSet.new([2, 3, 4, 7]) end)
    |> Enum.count()
  end

  def split_and_trim_left(input) do
    input
    |> String.split(" | ", trim: true)
    |> tl()
  end
end

defmodule SevenSegmentTwo do
  def solve() do
    Utils.lines()
    |> Enum.map(&split_input_output/1)
    |> Enum.map(&solve_one/1)
    |> Enum.sum()
  end

  def solve_one([input | [output]]) do
    [digit_1] = Enum.filter(input, &(String.length(&1) == 2))
    [digit_4] = Enum.filter(input, &(String.length(&1) == 4))
    [digit_7] = Enum.filter(input, &(String.length(&1) == 3))
    [digit_8] = Enum.filter(input, &(String.length(&1) == 7))
    [digit_6] = Enum.filter(input, &(String.length(&1) == 6 and not letters_in_word(digit_1, &1)))
    [digit_3] = Enum.filter(input, &(String.length(&1) == 5 and letters_in_word(digit_1, &1)))
    [digit_9] = Enum.filter(input, &(String.length(&1) == 6 and letters_in_word(digit_3, &1)))
    [digit_0] = Enum.filter(input, &(String.length(&1) == 6 and &1 not in [digit_9, digit_6]))
    [digit_5] = Enum.filter(input, &(String.length(&1) == 5 and letters_in_word(&1, digit_6)))

    digit_map = %{
      digit_0 => "0",
      digit_1 => "1",
      digit_3 => "3",
      digit_4 => "4",
      digit_5 => "5",
      digit_6 => "6",
      digit_7 => "7",
      digit_8 => "8",
      digit_9 => "9"
    }

    [digit_2] = Enum.filter(input, &(&1 not in Map.keys(digit_map)))
    digit_map = Map.put(digit_map, digit_2, "2")

    output
    |> Enum.map(&get_digit(digit_map, &1))
    |> Enum.join()
    |> String.to_integer()
  end

  def get_digit(digit_map, word) do
    d =
      digit_map
      |> Map.keys()
      |> Enum.filter(
        &(String.length(&1) == String.length(word) and
            letters_in_word(word, &1))
      )
      |> hd()

    digit_map[d]
  end

  def letters_in_word(letters, word) do
    String.split(letters, "", trim: true)
    |> Enum.map(&String.contains?(word, &1))
    |> Enum.all?()
  end

  def split_input_output(input) do
    String.split(input, " | ", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end
end
