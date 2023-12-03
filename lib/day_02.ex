defmodule Day02 do
  use Solution

  defmodule Game do
    defstruct [:id, :turns, :most]

    def from_string(string) do
      {id, rest} = parse_id(string)
      turns = parse_turns(rest)

      most =
        Enum.reduce(turns, %{}, fn turn, acc ->
          Enum.reduce(turn, acc, fn {color, count}, acc ->
            Map.update(acc, color, count, &max(&1, count))
          end)
        end)

      %__MODULE__{
        id: id,
        turns: turns,
        most: most
      }
    end

    def possible?(%__MODULE__{} = game, %{} = criteria) do
      Enum.all?(criteria, fn {color, count} ->
        case Map.fetch(game.most, color) do
          {:ok, most_count} ->
            most_count <= count

          :error ->
            true
        end
      end)
    end

    def power(%__MODULE__{} = game) do
      Enum.reduce(game.most, 1, fn {_, count}, acc ->
        count * acc
      end)
    end

    ## Private

    defp parse_id(string) do
      [label, turns] = Parse.parts(string, ":")
      [_, id] = Parse.parts(label, " ")
      {:ok, id} = Parse.as_integer(id)

      {id, turns}
    end

    defp parse_turns(string) do
      string
      |> Parse.parts(";")
      |> Enum.map(&parse_turn/1)
    end

    defp parse_turn(string) do
      string
      |> Parse.parts(",")
      |> Map.new(fn color_count ->
        {count, color} = Integer.parse(color_count, 10)

        {String.trim(color), count}
      end)
    end
  end

  def solution(:first, input) do
    input
    |> Parse.lines()
    |> Enum.map(&Game.from_string/1)
    |> Enum.filter(&Game.possible?(&1, %{"red" => 12, "green" => 13, "blue" => 14}))
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  def solution(:second, input) do
    input
    |> Parse.lines()
    |> Enum.map(&Game.from_string/1)
    |> Enum.map(&Game.power/1)
    |> Enum.sum()
  end
end
