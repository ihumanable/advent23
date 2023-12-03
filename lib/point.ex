defmodule Point do
  @type t :: {x :: integer(), y :: integer()}

  def neighbors({x, y}) do
    Span.neighbors({x, y, 1})
  end
end
