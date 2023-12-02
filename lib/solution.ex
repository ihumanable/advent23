defmodule Solution do
  @callback solution(which :: atom(), input :: String.t()) :: any()

  defmacro __using__(_) do
    quote do
      @behaviour Solution

      def solve(which, input) do
        with {:ok, input} <- Input.get(__MODULE__, input) do
          solution(which, input)
        end
      end
    end
  end
end
