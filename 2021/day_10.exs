defmodule SyntaxScoring do
  @day 10
  @input_path Path.expand("./2021/inputs/day_#{@day}.txt")

  @pairs %{"<" => ">", "{" => "}", "[" => "]", "(" => ")"}
  @scores %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

  def lines() do
    {:ok, contents} = File.read(@input_path)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def solve() do
    lines()
    |> Enum.map(&get_score/1)
    |> Enum.sum()
  end

  def get_score(line, stack \\ [])
  def get_score([], _stack), do: 0

  def get_score(line, stack) do
    [h | t] = line

    if h in Map.keys(@pairs) do
      get_score(t, [@pairs[h] | stack])
    else
      handle_right_bracket(line, stack)
    end
  end

  def handle_right_bracket([h | t], [h | t_stack]), do: get_score(t, t_stack)
  def handle_right_bracket([h | _t], [_h_stack | _t_stack]), do: @scores[h]
end

defmodule SyntaxScoringTwo do
  @pairs %{"<" => ">", "{" => "}", "[" => "]", "(" => ")"}
  @scores %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  def solve() do
    SyntaxScoring.lines()
    |> Enum.map(&get_closing_chars/1)
    |> Enum.filter(&(&1 != "corrupt"))
    |> Enum.map(&get_completion_score/1)
    |> Enum.sort()
    |> get_middle_value()
  end

  def get_closing_chars(line, stack \\ [])
  def get_closing_chars([], stack), do: stack

  def get_closing_chars(line, stack) do
    [h | t] = line

    if h in Map.keys(@pairs) do
      get_closing_chars(t, [@pairs[h] | stack])  # add to stack
    else
      handle_right_bracket(line, stack)
    end
  end

  def handle_right_bracket([h | t], [h | t_stack]), do: get_closing_chars(t, t_stack)  # remove from stack
  def handle_right_bracket(_line, _stack), do: "corrupt"

  defp get_completion_score(s), do: Enum.reduce(s, 0, fn x, acc -> 5 * acc + @scores[x] end)

  defp get_middle_value(l), do: Enum.at(l, trunc(length(l) / 2))
end
