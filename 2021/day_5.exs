defmodule Utils do
  @day 5
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def lines() do
    {:ok, contents} = File.read(@input_path)
    String.split(contents, "\n", trim: true)
  end
end

defmodule Vents do
  def co_ordinates() do
    Utils.lines()
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.reduce([], fn x, acc -> [format_co_ordinate(x) | acc] end)
    |> Enum.reverse()
  end

  def format_co_ordinate(l) do
    Enum.reduce(l, [], fn x, acc ->
      co_ordinate =
        x
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      [co_ordinate | acc]
    end)
  end
end

defmodule VentsOne do
  def solve() do
    Vents.co_ordinates()
    |> Enum.flat_map(&get_points/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_key, val} -> val >= 2 end)
  end

  def get_points([[x1, y1], [x2, y2]]) do
    case line_type([[x1, y1], [x2, y2]]) do
      "vertical" -> Enum.zip(List.duplicate(x1, abs(y2 - y1) + 1), y1..y2)
      "horizontal" -> Enum.zip(x1..x2, List.duplicate(y1, abs(x2 - x1) + 1))
      _ -> []
    end
  end

  def line_type([[x, _], [x, _]]), do: "vertical"
  def line_type([[_, y], [_, y]]), do: "horizontal"
  def line_type(_), do: nil
end

defmodule VentsTwo do
  def solve() do
    Vents.co_ordinates()
    |> Enum.flat_map(&get_points/1)
    |> Enum.frequencies()
    |> Enum.count(fn {_key, val} -> val >= 2 end)
  end

  def get_points([[x1, y1], [x2, y2]]) do
    case line_type([[x1, y1], [x2, y2]]) do
      "vertical" -> Enum.zip(List.duplicate(x1, abs(y2 - y1) + 1), y1..y2)
      "horizontal" -> Enum.zip(x1..x2, List.duplicate(y1, abs(x2 - x1) + 1))
      "diagonal" -> Enum.zip(x1..x2, y1..y2)
      _ -> []
    end
  end

  def line_type([[x, _], [x, _]]), do: "vertical"
  def line_type([[_, y], [_, y]]), do: "horizontal"

  def line_type([[x1, y1], [x2, y2]]) when abs((y2 - y1) / (x2 - x1)) == 1 do
    "diagonal"
  end

  def line_type(_), do: nil
end
