defmodule DepthMeasurement do
  @day 1
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def get_readings() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> count()
  end

  defp count(l, total \\ 0)

  defp count(l, total) when length(l) == 1 do
    total
  end

  defp count([h1 | [h2 | t]], total) do
    case h2 > h1 do
      true -> count([h2 | t], total + 1)
      false -> count([h2 | t], total)
    end
  end
end

defmodule DepthMeasurementTwo do
  @day 1
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def get_readings() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> count()
  end

  defp count(l, total \\ 0)

  defp count(l, total) when length(l) == 3 do
    total
  end

  defp count([h1 | [h2 | [h3 | [h4 | t]]]], total) do
    next = [h2 | [h3 | [h4 | t]]]

    case h2 + h3 + h4 > h1 + h2 + h3 do
      true -> count(next, total + 1)
      false -> count(next, total)
    end
  end
end
