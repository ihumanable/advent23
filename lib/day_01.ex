defmodule Day01 do
  use Solution

  @type digit :: 0..9
  @type calibration_value :: 0..99

  def solution(:first, input) do
    digits = Mapping.numeral_to_digit()

    do_solve(input, digits)
  end

  def solution(:second, input) do
    digits = Map.merge(Mapping.numeral_to_digit(), Mapping.word_to_digit())

    do_solve(input, digits)
  end

  ## Private

  @spec do_solve(input :: String.t(), digits :: %{String.t() => digit()}) :: non_neg_integer()
  defp do_solve(input, digits) do
    input
    |> Parse.lines()
    |> Stream.map(&extract_digits(&1, digits))
    |> Stream.map(&calibration_value/1)
    |> Enum.sum()
  end

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
