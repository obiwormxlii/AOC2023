# parse input
## separate games by line
## group rounds by game
## pick out rounds
## pick out colors
## get color count
# add color counts together
# determine if color counts are over the limit
# split games into possible and impossible
# sum impossible game id's

# test_input = """
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# """

input = File.read!("./day2.txt")
# split games
all_games = String.split(input, "\n", trim: true)

# working game-by-game

defmodule Cube do
  def parse_game([head | tail], games) do
    # separate title and rounds
    [game_title, game_rounds] = String.split(head, ":", trim: true)

    game_index =
      String.split(game_title, " ", trim: true)
      |> Enum.at(1)
      |> then(fn result ->
        String.to_integer(result)
      end)

    # IO.inspect(game_index)

    rounds =
      String.split(game_rounds, ";", trim: true)
      |> then(fn result -> Enum.map(result, &String.split(&1, ",", trim: true)) end)

    # IO.inspect(rounds)

    colors =
      Enum.concat(rounds)
      |> then(fn result -> Enum.map(result, &String.split(&1, " ", trim: true)) end)
      |> Enum.group_by(fn [_, color] -> color end)

    # IO.inspect([colors, "\n"])

    red = sum_color(colors["red"], 12)
    green = sum_color(colors["green"], 13)
    blue = sum_color(colors["blue"], 14)

    colors = red ++ green ++ blue
    is_valid? = not Enum.find(colors, false, fn x -> x == true end)
    # IO.inspect(is_valid?)

    # IO.inspect(blue)

    games =
      games ++
        [
          %{
            :index => game_index,
            :rounds => rounds,
            :red => red,
            :green => green,
            :blue => blue,
            :is_valid? => is_valid?
          }
        ]

    parse_game(tail, games)
  end

  def parse_game([], games) do
    games
  end

  def sum_color(color, max_count) do
    Enum.map(color, fn [amount, color] -> [String.to_integer(amount), color] end)
    |> Enum.concat()
    |> Enum.filter(&is_integer/1)
    |> Enum.map(fn x -> x > max_count end)
  end
end

games = []
games = Cube.parse_game(all_games, games)

# IO.inspect(games)

valid_games = Enum.filter(games, fn game -> game.is_valid? end)
# IO.inspect(valid_games)

solution =
  Enum.map(valid_games, fn game -> Map.get(game, :index) end)
  |> Enum.sum()

IO.inspect(solution)
