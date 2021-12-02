defmodule PositionMeasurement do
  @day 2
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def get_readings() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1))
    |> get_position()
  end

  def get_position(position, horizontal \\ 0, depth \\ 0)
  def get_position([], horizontal, depth), do: horizontal * depth

  def get_position([[direction, units] | t], horizontal, depth) do
    units = String.to_integer(units)

    case direction do
      "forward" -> get_position(t, horizontal + units, depth)
      "down" -> get_position(t, horizontal, depth + units)
      "up" -> get_position(t, horizontal, depth - units)
    end
  end
end

defmodule PositionMeasurementTwo do
  @day 2
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  def get_readings() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1))
    |> get_position()
  end

  def get_position(position, horizontal \\ 0, depth \\ 0, aim \\ 0)
  def get_position([], horizontal, depth, _aim), do: horizontal * depth

  def get_position([[direction, units] | t], horizontal, depth, aim) do
    units = String.to_integer(units)

    case direction do
      "forward" -> get_position(t, horizontal + units, depth + aim * units, aim)
      "down" -> get_position(t, horizontal, depth, aim + units)
      "up" -> get_position(t, horizontal, depth, aim - units)
    end
  end
end
