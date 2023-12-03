defmodule Span do
  @type t :: {x :: integer(), y :: integer(), width :: integer()}

  @spec neighbors(span :: t()) :: [Point.t()]
  def neighbors({x, y, width}) do
    Enum.concat([
      points({x - 1, y - 1, width + 2}),
      [{x - 1, y}, {x + width, y}],
      points({x - 1, y + 1, width + 2})
    ])

  end

  def points({x, y, width}) do
    Enum.map(x..(x + width - 1), &{&1, y})
  end
end
