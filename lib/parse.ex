defmodule Parse do
  @moduledoc """
  Helpers for working with puzzle input
  """

  @doc """
  Breaks a string into its lines
  """
  @spec lines(string :: String.t()) :: [String.t()]
  def lines(string) do
    String.split(string, "\n", trim: true)
  end

  @doc """
  Breaks a string into its characters
  """
  @spec characters(string :: String.t()) :: [String.t()]
  def characters(string) do
    String.split(string, "", trim: true)
  end

  @doc """
  Converts each string to an integer

  This function uses `as_integer/2` for conversion discarding any `:error`
  values.
  """
  @spec as_integers(strings :: [String.t()]) :: [integer()]
  def as_integers(strings, base \\ 10) when is_list(strings) do
    strings
    |> Enum.map(&as_integer(&1, base))
    |> Enum.reject(& &1 == :error)
    |> Enum.map(fn {:ok, integer} -> integer end)
  end

  @doc """
  Converts a string into an integer

  If conversion is successful `{:ok, integer()}` is returned otherwise `:error`
  is returned.
  """
  @spec as_integer(string :: String.t(), base :: integer()) :: {:ok, integer()} | :error
  def as_integer(string, base \\ 10) do
    case Integer.parse(string, base) do
      {integer, ""} ->
        {:ok, integer}

      _ ->
        :error
    end
  end
end
