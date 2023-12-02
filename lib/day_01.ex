defmodule Day01 do
  use Solution

  @type digit :: 0..9
  @type calibration_value :: 0..99

  @digit_numerals %{
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
  }

  @digit_words %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
  }

  @digits Map.merge(@digit_numerals, @digit_words)

  def solution(:first, input) do
    input
    |> Parse.lines()
    |> Enum.map(&extract_digits(&1, @digit_numerals))
    |> Enum.map(&calibration_value/1)
    |> Enum.sum()
  end

  def solution(:second, input) do
    input
    |> Parse.lines()
    |> Enum.map(&extract_digits(&1, @digits))
    |> Enum.map(&calibration_value/1)
    |> Enum.sum()
  end

  ## Private

  @spec calibration_value(digits :: [digit()]) :: calibration_value()
  defp calibration_value(digits) do
    first = List.first(digits)
    last = List.last(digits)

    (first * 10) + last
  end

  @spec extract_digits(string :: String.t(), digits :: %{String.t() => digit()}, acc :: [digit()]) :: [digit()]
  defp extract_digits(string, digits, acc \\ [])

  defp extract_digits("", _, acc) do
    acc
    |> Enum.reject(& &1 == :error)
    |> Enum.reverse()
  end

  defp extract_digits(<<_, rest::binary>> = string, digits, acc) do
    digit =
      Enum.find_value(digits, :error, fn {word, value} ->
        if String.starts_with?(string, word) do
          value
        else
          false
        end
      end)

    extract_digits(rest, digits, [digit | acc])
  end
end
