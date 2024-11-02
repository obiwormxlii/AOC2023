# Refactor day 2 part 1 with claude.
# this is the first time I've used elixir, I want to see what
# good elixir code looks like.

# I then modified the code to solve day 2 part 2

defmodule CubeGame do
  # Define the maximum allowed cubes for each color as a module attribute
  # This makes it easy to change the limits and keeps the magic numbers in one place
  @max_cubes %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  @doc """
  Main solving function that processes the input file and returns the sum of valid game IDs.
  Takes a file path as input and returns an integer.
  """
  def solve1(input_file) do
    input_file
    |> File.read!()                              # Read the entire file as a string
    |> String.split("\n", trim: true)            # Split into lines, removing empty ones
    |> Enum.map(&parse_game/1)                   # Convert each line into {game_id, rounds} tuple
    |> Enum.filter(&round_valid?/1)               # Keep only the valid games
    |> Enum.map(fn {game_id, _rounds} -> game_id end)  # Extract just the game IDs
    |> Enum.sum()                                # Sum up all valid game IDs
  end

  # """
  # Parses a single game line into a tuple of {game_id, rounds}.
  # Example input: "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
  # Returns: {1, [%{"blue" => 3, "red" => 4}, %{"red" => 1, "green" => 2, "blue" => 6}, %{"green" => 2}]}
  # """
  defp parse_game(game_string) do
    # Split the game string into title and rounds parts
    [game_info, rounds] = String.split(game_string, ":", trim: true)

    # Extract the game ID number from the title (e.g., "Game 1" -> 1)
    {game_id, _} =
      game_info
      |> String.split(" ", trim: true)
      |> List.last()
      |> Integer.parse()

    # Parse all rounds and return tuple with game ID and rounds data
    rounds_data =
      rounds
      |> String.split(";")           # Split into individual rounds
      |> Enum.map(&parse_round/1)    # Parse each round into a map
      |> Enum.reduce(%{}, &find_color_max/2)


    # cube_max =
    #   max_cubes(rounds_data)

    # IO.inspect(rounds_data)
    {game_id, rounds_data}
  end

  # """
  # Parses a single round string into a map of colors and their counts.
  # Example input: " 3 blue, 4 red"
  # Returns: %{"blue" => 3, "red" => 4}
  # """
  defp parse_round(round) do
    round
    |> String.split(",", trim: true)         # Split into individual color counts
    |> Enum.map(&parse_cube_count/1)         # Convert each color count to a tuple
    |> Map.new()                          # Convert list of tuples to a map
  end

  # """
  # Parses a single color count string into a color-count tuple.
  # Example input: " 3 blue"
  # Returns: {"blue", 3}
  # """
  defp parse_cube_count(cube_string) do
    [count, color] =
      cube_string
      |> String.trim()                       # Remove whitespace
      |> String.split(" ", trim: true)       # Split into count and color

    {count, _} = Integer.parse(count)        # Convert count to integer
    {color, count}                           # Return as tuple for Map.new/1
  end


  # """
  # Checks if a single round is valid by comparing each color count against maximum allowed.
  # Takes a map of color counts and returns boolean.
  # """
  defp round_valid?({__game_id, round}) do
    # IO.inspect(round)
    Enum.all?(round, fn {color, count} ->
      count <= Map.get(@max_cubes, color, 0)  # Compare against max allowed cubes
    end)
  end

  def solve2(input_file) do
    input_file
    |> File.read!()                              # Read the entire file as a string
    |> String.split("\n", trim: true)            # Split into lines, removing empty ones
    |> Enum.map(&parse_game/1)                 # Convert each line into {game_id, rounds} tuple
    |> Enum.map(fn {game_id, rounds} -> cube_power({game_id, rounds}) end)
    |> Enum.sum()

  end

  defp find_color_max(color, acc) do
    Map.merge(acc, color, fn _k, v1, v2 -> Enum.max([v1,v2]) end)
  end

  defp cube_power({_game_id, rounds}) do
    Map.values(rounds)
    |> Enum.reduce(1, &(&1 * &2))
  end



end

# Run the solution
solution = CubeGame.solve1("day2.txt")
IO.puts("part1 Solution: #{solution}")

solution = CubeGame.solve2("day2.txt")
IO.puts("part2 Solution: #{solution}")
