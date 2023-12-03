defmodule Day03 do
  use Solution

  defmodule Schematic do
    defstruct [parts: %{}, symbols: %{}]

    def from_lines(lines) do
      lines
      |> Enum.map(&parse_line/1)
      |> Enum.with_index()
      |> Enum.reduce(%__MODULE__{}, fn {line, y}, schematic ->
        Enum.reduce(line, schematic, fn
          {:part, number, x, width}, schematic ->
            add_part(schematic, number, {x, y, width})

          {:symbol, symbol, x}, schematic ->
            add_symbol(schematic, symbol, {x, y})
        end)
      end)
    end

    def add_part(%__MODULE__{} = schematic, number, span) do
      %__MODULE__{schematic | parts: Map.put(schematic.parts, span, number)}
    end

    def add_symbol(%__MODULE__{} = schematic, symbol, point) do
      %__MODULE__{schematic | symbols: Map.put(schematic.symbols, point, symbol)}
    end

    def connected?(%__MODULE__{} = schematic, span) do
      span
      |> Span.neighbors()
      |> Enum.any?(&symbol?(schematic, &1))
    end

    def connected_parts(%__MODULE__{} = schematic) do
      connected_spans =
        schematic.parts
        |> Map.keys()
        |> Enum.filter(&connected?(schematic, &1))

      Map.take(schematic.parts, connected_spans)
    end

    def gears(%__MODULE__{} = schematic) do
      # Convert the parts into their points
      part_points =
        Enum.reduce(schematic.parts, %{}, fn {span, part}, acc ->
          span
          |> Span.points()
          |> Enum.reduce(acc, &Map.put(&2, &1, part))
        end)

      schematic.symbols
      |> Stream.filter(fn {_, symbol} ->
        # Only consider '*'
        symbol == ?*
      end)
      |> Stream.map(fn {point, symbol} ->
        # Find all the parts the symbol is connected to
        neighbors = Point.neighbors(point)

        connected =
          part_points
          |> Map.take(neighbors)
          |> Map.values()
          |> Enum.uniq()

        case connected do
          [a, b] ->
            # If it's exactly 2 parts, calculate the gear ratio and include it
            {point, symbol, connected, a * b}

          _ ->
            # Otherwise mark this symbol as an error, removed in next step
            :error
        end
      end)
      |> Stream.reject(& &1 == :error)
      |> Enum.to_list()
    end

    def symbol?(%__MODULE__{} = schematic, point) do
      Map.has_key?(schematic.symbols, point)
    end

    ## Private

    defp classify(character) do
      case character do
        character when character in ?0..?9 ->
          :digit

        ?. ->
          :period

        _ ->
          :symbol
      end
    end

    defp parse_line(line, state \\ :scan, index \\ 0, acc \\ [])

    defp parse_line("", :scan, _, acc) do
      Enum.reverse(acc)
    end

    defp parse_line("", {:part, digits, start, width}, _, acc) do
      Enum.reverse([{:part, part_number(digits), start, width} | acc])
    end

    defp parse_line(<<first::utf8, rest::binary>>, :scan, index, acc) do
      case classify(first) do
        :digit ->
          # Start a part
          parse_line(rest, {:part, [first], index, 1}, index + 1, acc)

        :period ->
          # Continue scanning
          parse_line(rest, :scan, index + 1, acc)

        :symbol ->
          # Symbol found
          symbol = {:symbol, first, index}
          parse_line(rest, :scan, index + 1, [symbol | acc])
      end
    end

    defp parse_line(<<first::utf8, rest::binary>>, {:part, digits, start, width}, index, acc) do
      case classify(first) do
        :digit ->
          # Continue a part
          parse_line(rest, {:part, [first | digits], start, width + 1}, index + 1, acc)

        :period ->
          # Finish the part and return to scanning
          part = {:part, part_number(digits), start, width}
          parse_line(rest, :scan, index + 1, [part | acc])

        :symbol ->
          # Symbol, finish and add the part, then add the symbol, then continue
          # scanning
          part = {:part, part_number(digits), start, width}
          symbol = {:symbol, first, index}
          parse_line(rest, :scan, index + 1, [symbol, part | acc])
      end
    end

    defp part_number(digits) do
      {:ok, number} =
        digits
        |> Enum.reverse()
        |> List.to_string()
        |> Parse.as_integer()

      number
    end
  end

  def solution(:first, input) do
    input
    |> Parse.lines()
    |> Schematic.from_lines()
    |> Schematic.connected_parts()
    |> Map.values()
    |> Enum.sum()
  end

  def solution(:second, input) do
    input
    |> Parse.lines()
    |> Schematic.from_lines()
    |> Schematic.gears()
    |> Enum.map(&elem(&1, 3))
    |> Enum.sum()
  end
end
