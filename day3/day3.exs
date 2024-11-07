input = File.read!("day3.txt")
test_input = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""


defmodule Day3 do

  def solve(input) do
    coordinates = String.split(input, "\n", trim: true)
    |> Enum.scan(%{:x => 0}, fn line, acc ->
      parse_line(line, acc)
    end)
    |> Enum.flat_map(&Map.fetch!(&1, :col))

    valid = Enum.map(coordinates, & find_valid(&1, coordinates))
    |> Enum.filter(fn x -> x != nil end)

    IO.inspect(valid)


  end

  defp parse_line(row, acc) do
      col = String.split(row, "", trim: true)
        |>Enum.scan(
          %{:x => acc.x, :y => 0}, fn col, acc1 ->
            parse_col(col, acc1)
        end
        )

      %{:x => acc.x + 1, :col => col}
  end

  defp parse_col(col, acc) do
    %{:x => acc.x, :y => acc.y + 1, :sym => col}

  end

  defp find_valid(row, list) do
        case row do
          x when x.sym in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
            valid = Enum.filter(list, fn x ->
              ((x.x == row.x or x.x == row.x-1 or x.x == row.x+1) and (x.y == row.y-1 or x.y == row.y+1)) or
              ((x.y == row.y or x.y == row.y-1 or x.y == row.y+1) and (x.x == row.x-1 or x.x == row.x+1))
            end)
            |> Enum.any?(fn x ->
              x.sym not in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
            end)

          Map.put(row, :valid, valid)
          _ -> Map.put(row, :valid, false)
        end

  end

  # defp is_valid?(line, list) do
  #   case line do
  #   end

  # end

end

test = true

solution =
  unless test do
    Day3.solve(input)
  else
    sum = Day3.solve(test_input)
    # IO.inspect(sum)
    4361 == sum
  end

IO.inspect(["solution",  solution])
