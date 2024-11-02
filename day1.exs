input = File.read!("./input.txt")
# input = "ninefiveqmgnhrdndclldxtjmqmkseven1lcjlqddmbnn"

defmodule Day1 do
  def replace_string([head | tail], string) do
    string = String.replace(string, elem(head, 0), elem(head, 1))

    replace_string(tail, string)
  end

  def replace_string([], string) do
    string
  end

  def parse_numbers(line) do
    map = %{
      "one" => "o1e",
      "two" => "t2o",
      "three" => "t3e",
      "four" => "f4r",
      "five" => "f5e",
      "six" => "s6x",
      "seven" => "s7n",
      "eight" => "e8t",
      "nine" => "n9e",
      "zero" => "z00"
    }

    replace_string(Map.to_list(map), line)
  end

  def is_char_integer?(char) do
    char >= "0" and char <= "9"
  end

  def process_line(line) do
    IO.puts(line)
    line=parse_numbers(line)
    IO.puts([line, "\n"])


    digits =
      String.splitter(line, "", trim: true)
      |> Stream.filter(&is_char_integer?/1)
      |> Enum.to_list()

    first = List.first(digits)
    last = List.last(digits)
    String.to_integer(first <> last)
  end

  def day1(calibration_values) do
    Enum.map(calibration_values, &process_line/1)
  end
end

calibration_values = String.split(input, "\n", trim: true)
results = Day1.day1(calibration_values)

sum = Enum.sum(results)

IO.puts(sum)
