defmodule RopeBridge do
  @start [0, 0]

  def part_one do
    setup()
    |> Enum.reduce([@start, [@start]], fn move, [head, tail_positions] ->
      current_tail_position = hd(tail_positions)

      new_head = move_head(move, head)
      new_tail = move_tail(new_head, current_tail_position)

      [new_head, [new_tail | tail_positions]]
    end)
    |> tl()
    |> hd()
    |> MapSet.new()
    |> MapSet.size()
  end

  def part_two do
    setup()
    |> Enum.reduce([@start, [@start], List.duplicate(@start, 9)], fn move, acc ->
      [head, knot_nine_positions, current_tails] = acc
      new_head = move_head(move, head)

      new_tail_positions =
        current_tails
        |> Enum.reverse()
        |> Enum.reduce([new_head], fn tail, acc ->
          new_position = acc |> hd() |> move_tail(tail)

          [new_position | acc]
        end)
        |> Enum.drop(-1)

      [new_head, [hd(new_tail_positions) | knot_nine_positions] | [new_tail_positions]]
    end)
    |> List.to_tuple()
    |> elem(1)
    |> MapSet.new()
    |> MapSet.size()
  end

  defp setup do
    Path.expand("./inputs/day_9.txt")
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [x, y] -> [x, String.to_integer(y)] end)
    |> Enum.reduce([], fn [dir, steps], acc -> List.duplicate([dir, 1], steps) ++ acc end)
    |> Enum.reverse()
  end

  defp move_head(["U", steps], [x1, y1]), do: [x1, y1 + steps]
  defp move_head(["D", steps], [x1, y1]), do: [x1, y1 - steps]
  defp move_head(["R", steps], [x1, y1]), do: [x1 + steps, y1]
  defp move_head(["L", steps], [x1, y1]), do: [x1 - steps, y1]

  defp move_tail(head, tail)
  # straight up
  defp move_tail([x1, y1], [x1, y2]) when y1 == y2 + 2, do: [x1, y2 + 1]
  # diagonal right up
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 + 1 and y1 == y2 + 2, do: [x2 + 1, y2 + 1]
  # diagonal left up
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 - 1 and y1 == y2 + 2, do: [x2 - 1, y2 + 1]
  # diagonal left up
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 - 2 and y1 == y2 + 1, do: [x2 - 1, y2 + 1]
  # straight left
  defp move_tail([x1, y1], [x2, y1]) when x1 == x2 - 2, do: [x2 - 1, y1]
  # diagonal down left
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 - 2 and y1 == y2 - 1, do: [x2 - 1, y2 - 1]
  # diagonal down left
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 - 1 and y1 == y2 - 2, do: [x2 - 1, y2 - 1]
  # straight down
  defp move_tail([x1, y1], [x1, y2]) when y1 == y2 - 2, do: [x1, y2 - 1]
  # diagonal down right
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 + 1 and y1 == y2 - 2, do: [x2 + 1, y2 - 1]
  # diagonal down right
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 + 2 and y1 == y2 - 1, do: [x2 + 1, y2 - 1]
  # straight right
  defp move_tail([x1, y1], [x2, y1]) when x1 == x2 + 2, do: [x2 + 1, y1]
  # diagonal up right
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 + 2 and y1 == y2 + 1, do: [x2 + 1, y2 + 1]

  ## Part two
  # diagonal up right
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 + 2 and y1 == y2 + 2, do: [x2 + 1, y2 + 1]
  # diagonal up left
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 - 2 and y1 == y2 + 2, do: [x2 - 1, y2 + 1]
  # diagonal down right
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 + 2 and y1 == y2 - 2, do: [x2 + 1, y2 - 1]
  # diagonal down left
  defp move_tail([x1, y1], [x2, y2]) when x1 == x2 - 2 and y1 == y2 - 2, do: [x2 - 1, y2 - 1]
  defp move_tail(_head, tail), do: tail
end

RopeBridge.part_one()
|> IO.inspect()

RopeBridge.part_two()
|> IO.inspect()
