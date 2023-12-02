defmodule Input do
  def get(solution, which) do
    day =
      solution
      |> to_string()
      |> String.slice(-2, 2)

    [".", "input", day, which]
    |> Path.join()
    |> File.read()
  end
end
