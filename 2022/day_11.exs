defmodule Monkey do
  defstruct [:operation, :test, count: 0, items: []]
end

defmodule MonkeyBusiness do
  alias Monkey

  @number_of_rounds 10_000
  @number_of_monkeys 8

  def run do
    monkeys =
      Path.expand("./inputs/day_11.txt")
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.chunk_every(6)
      |> Enum.map(&parse_instructions/1)
      |> Enum.zip(0..@number_of_monkeys)
      |> Map.new(fn {monkey, index} -> {index, monkey} end)

    common_divider =
      monkeys
      |> Map.values()
      |> Enum.map(&hd(&1.test))
      |> Enum.product()

    Enum.reduce(0..(@number_of_rounds - 1), monkeys, fn _, acc ->
      do_round(acc, common_divider)
    end)
    |> Map.values()
    |> Enum.map(& &1.count)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  defp do_round(monkeys, common_divider) do
    Enum.reduce(0..(@number_of_monkeys - 1), monkeys, fn index, acc ->
      %Monkey{operation: operation, test: test, items: items, count: count} = acc[index]

      # get monkey index and their new items
      monkey_items =
        Enum.reduce(items, %{}, fn item, acc ->
          item
          |> do_operation(operation)
          |> rem(common_divider)
          |> then(fn new_item ->
            if rem(new_item, hd(test)) == 0 do
              index = Enum.at(test, 1)
              current_items = Map.get(acc, index, [])
              Map.put(acc, index, [new_item | current_items])
            else
              index = Enum.at(test, 2)
              current_items = Map.get(acc, index, [])
              Map.put(acc, index, [new_item | current_items])
            end
          end)
        end)

      # set items to [] and update count for monkey that has just been completed
      completed_monkey = %Monkey{operation: operation, test: test, count: length(items) + count}

      # add new items to each monkey
      Enum.reduce(monkey_items, acc, fn {index, items}, acc ->
        {_, new} = Map.get_and_update(acc[index], :items, &{&1, &1 ++ items})
        Map.put(acc, index, new)
      end)
      |> Map.put(index, completed_monkey)
    end)
  end

  defp do_operation(number, [op, "old"]), do: do_operation(number, [op, number])
  defp do_operation(number, ["+", val]), do: number + val
  defp do_operation(number, ["-", val]), do: number - val
  defp do_operation(number, ["*", val]), do: number * val

  defp parse_instructions(monkey_text) do
    items =
      monkey_text
      |> Enum.at(1)
      |> String.replace_leading("  Starting items: ", "")
      |> String.split(":", trim: true)
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.trim_leading/1)
      |> Enum.map(&String.to_integer/1)

    operation =
      monkey_text
      |> Enum.at(2)
      |> String.replace_leading("  Operation: new = old ", "")
      |> String.split(" ")
      |> then(fn [op, num] ->
        if num == "old" do
          [op, num]
        else
          [op, String.to_integer(num)]
        end
      end)

    test =
      monkey_text
      |> Enum.slice(-3..-1)
      |> Enum.map(fn
        "  Test: divisible by " <> n -> n
        c -> String.slice(c, -1..-1)
      end)
      |> Enum.map(&String.to_integer/1)

    %Monkey{operation: operation, test: test, items: items}
  end
end

# Part 2
MonkeyBusiness.run()
|> IO.inspect()
