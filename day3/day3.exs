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
    |> Enum.map(&find_valid/1)

    # IO.inspect(coordinates)

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

  defp find_valid(row) do
    # IO.inspect(row.col)
    row.col
    |> Enum.each(fn col ->
        case col do
          %{sym: "."} -> IO.inspect(:error)
          _ -> IO.inspect(:ok)
        end

        IO.inspect(col)
      end
    )

  end


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
