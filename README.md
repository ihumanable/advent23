# Advent23

Advent of Code 2023

## Usage

Each solution uses `Solution` so any puzzle solution is available by running the following in iex

```elixir
DayXX.solve(:name_of_solution, "input_to_use")
```

For example `Day01` defines both a `:first` and `:second` solution, to run the `:first` solution agains the `"inputs/01/example-1"` input the following can be used

```elixir
iex(1)> Day01.solve(:first, "example-1")
142
```