defmodule Mapping do
  @moduledoc """
  Common useful mappings that can assist with parsing and understanding puzzle input

  Function names follow a convention {source}_to_{destination}

  For example the mapping that maps from string numerals to digit values is named
  numeral_to_digit
  """

  @numeral_to_digit %{
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

  @word_to_digit %{
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

  def numeral_to_digit do
    @numeral_to_digit
  end

  def word_to_digit do
    @word_to_digit
  end
end
