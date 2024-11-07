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
    coordinates =
      String.split(input, "\n", trim: true)
      |> Enum.scan(%{:x => 0}, fn line, acc ->
        parse_line(line, acc)
      end)
      |> Enum.flat_map(&Map.fetch!(&1, :col))

    valid =
      Enum.map(coordinates, &find_valid(&1, coordinates))
      |> Enum.filter(fn x -> x != nil end)
      |> Enum.filter(fn x -> x.sym in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] end)

    # IO.inspect(valid)

    numbers = get_numbers([], valid)
    |> Enum.filter(&Enum.any?(&1, fn x -> x.valid  end))
    |> Enum.map(
      fn x ->
        Enum.map(x, &Map.get(&1, :sym))
        |> Enum.join("")
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()


    # IO.inspect(numbers)
  end

  defp parse_line(row, acc) do
    col =
      String.split(row, "", trim: true)
      |> Enum.scan(
        %{:x => acc.x, :y => 0},
        fn col, acc1 ->
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
        valid =
          Enum.filter(list, fn x ->
            Enum.any?([
              {x.x - 1, x.y - 1}, {x.x, x.y - 1}, {x.x + 1, x.y - 1},
            {x.x - 1, x.y},                     {x.x + 1, x.y},
            {x.x - 1, x.y + 1}, {x.x, x.y + 1}, {x.x + 1, x.y + 1}
            ])
            end)
          |> Enum.any?(fn x ->
            x.sym not in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
          end)

        Map.put(row, :valid, valid)

      _ ->
        Map.put(row, :valid, false)
    end
  end

  defp get_numbers(acc, [head | tail]) when length(tail) > 0 do
    case head do
      x when hd(tail).x == x.x and hd(tail).y == x.y + 1 ->
        get_numbers(acc, tail, [x])
        _ ->
          get_numbers(acc, tail)
    end
  end

  defp get_numbers(acc, [head | tail], result) do
    case List.last(result) do
      x when head.x == x.x and head.y == x.y + 1 ->
        get_numbers(acc, tail, result ++ [head])
      _ ->
        get_numbers(acc++[result], [head]++tail)
    end
  end

  defp get_numbers(acc, [], result) do
    acc ++ [result]
  end

end

test = false

solution =
  unless test do
    Day3.solve(input)
  else
    sum = Day3.solve(test_input)
    # IO.inspect(sum)
    4361 == sum
  end
# IO.inspect(["input", input |> String.split("\n")])
IO.inspect(["solution", solution])
