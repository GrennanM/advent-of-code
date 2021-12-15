defmodule SmokeEm do
  @day 9
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def rows() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, "", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve() do
    rows = rows()
    col_length = length(hd(rows))
    row_length = length(rows)

    Enum.flat_map(0..(col_length - 1), fn c ->
      Enum.map(0..(row_length - 1), fn r ->
        get_low_point(rows, r, c)
      end)
    end)
    |> Enum.filter(&(&1 != false))
    |> Enum.reduce(0, fn x, acc -> acc + x + 1 end)
  end

  def get_low_point(rows, row_index, col_index) do
    adjacent_points = get_adjacent_points(rows, row_index, col_index)

    current_row = Enum.at(rows, row_index)
    current_value = Enum.at(current_row, col_index)

    case current_value < Enum.min(adjacent_points) do
      true -> current_value
      false -> false
    end
  end

  defp get_adjacent_points(rows, row_index, col_index) do
    current_row = Enum.at(rows, row_index)
    row_above = get_row_above(rows, row_index)
    row_below = get_row_below(rows, row_index)

    [
      get_left(current_row, col_index),
      get_right(current_row, col_index),
      get_above(current_row, row_above, col_index),
      get_below(current_row, row_below, col_index)
    ]
  end

  def get_row_above(_rows, 0), do: :none
  def get_row_above(rows, row_index), do: Enum.at(rows, row_index - 1)

  def get_row_below(rows, row_index) when length(rows) == row_index + 1 do :none end
  def get_row_below(rows, row_index), do: Enum.at(rows, row_index + 1)

  def get_left(_row, 0), do: :none
  def get_left(row, i), do: Enum.at(row, i - 1)

  def get_right(row, i) when length(row) == i + 1 do :none end
  def get_right(row, i), do: Enum.at(row, i + 1)

  def get_below(_row, :none, _i), do: :none
  def get_below(_row, row_below, i), do: Enum.at(row_below, i)

  def get_above(_row, :none, _i), do: :none
  def get_above(_row, row_above, i), do: Enum.at(row_above, i)
end

defmodule SmokeEmTwo do
  def solve() do
    rows = SmokeEm.rows()
    col_length = length(hd(rows))
    row_length = length(rows)

    low_points =
      Enum.flat_map(0..(col_length - 1), fn c ->
        Enum.map(0..(row_length - 1), fn r ->
          get_low_point(rows, r, c)
        end)
      end)
      |> Enum.filter(&(&1 != false))

    low_points
    |> Enum.map(&get_basin_total([&1], rows))
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.reduce(1, fn x, acc -> acc * x end)
  end

  def get_basin_total(low_point, rows, completed \\ MapSet.new())
  def get_basin_total([], _rows, completed), do: MapSet.size(completed)

  def get_basin_total([{low_point_value, row_index, col_index} | t], rows, completed) do
    completed = MapSet.put(completed, {low_point_value, row_index, col_index})

    rows
    |> get_adjacent_points(row_index, col_index)
    |> Enum.filter(fn {val, _, _} -> val < 9 and val != false end)
    |> Enum.filter(fn x -> x not in completed end)
    |> Kernel.++(t)
    |> get_basin_total(rows, completed)
  end

  def get_low_point(rows, row_index, col_index) do
    adjacent_points = get_adjacent_points(rows, row_index, col_index)

    current_row = Enum.at(rows, row_index)
    current_value = Enum.at(current_row, col_index)

    case is_low_point?(current_value, adjacent_points) do
      true -> {current_value, row_index, col_index}
      false -> false
    end
  end

  def get_adjacent_points(rows, row_index, col_index) do
    current_row = Enum.at(rows, row_index)
    row_above = SmokeEm.get_row_above(rows, row_index)
    row_below = SmokeEm.get_row_below(rows, row_index)

    left = SmokeEm.get_left(current_row, col_index)
    right = SmokeEm.get_right(current_row, col_index)
    above = SmokeEm.get_above(current_row, row_above, col_index)
    below = SmokeEm.get_below(current_row, row_below, col_index)

    [
      {left, row_index, col_index - 1},
      {right, row_index, col_index + 1},
      {above, row_index - 1, col_index},
      {below, row_index + 1, col_index}
    ]
  end

  def is_low_point?(current_value, values) do
    min_value =
      values
      |> Enum.map(fn {x, _, _} -> x end)
      |> Enum.min()

    current_value < min_value
  end
end
